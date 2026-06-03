import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/mixins/transactions_cluster_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';
import 'package:wiigold/app/data/models/entities/payment_methods_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/common/widgets/layout/totp_confirm_dialog.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? THEME & IMAGES

//? MIXINS

//? WIDGETS

//? UTILS

class BuyController extends GetxController
    with LoadingMixin, TransactionsClusterMixin {
  final Logger logger = Logger(module: "BuyController");

  final WalletRepository _walletRepository = WalletRepository();

  final WalletController walletController = Get.find<WalletController>();

  final FinancialController _financialController = Get.find();

  RxList<PaymentMethodType> get availablePaymentMethods =>
      _financialController.paymentMethods;

  RxList<PaymentMethod> get availablePaymentMethodsDetail =>
      _financialController.paymentMethodDetails;

  final RxString selectedPaymentMethodId = RxString('');

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  Timer? _debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 700);

  final RxBool isBlocked = true.obs;

  //? buyViewForm
  final buyFormKey = GlobalKey<FormState>();

  final payableAmountController = TextEditingController(text: '');
  final receivableAmountController = TextEditingController(text: '');

  final paymentMethodsController = TextEditingController(text: '');

  final buyDataFormKey = GlobalKey<FormState>();

  final RxString currencyTarget = 'usd'.obs;

  final Rx<AssetBalance?> selectedToken = Rx(null);
  RxList<AssetBalance> tokens = <AssetBalance>[].obs;

  late bool tesoreryAvailable = false;

  final RxDouble rateConvertion = 0.0.obs;
  final RxDouble comission = 0.0.obs;

  //? buyDataViewForm

  final ValueNotifier<String?> proofImageController = ValueNotifier(null);
  final TextEditingController proofController = TextEditingController(text: "");

  @override
  void onInit() async {
    super.onInit();

    chargeData();

    _initializePaymentMethods();
  }

  Future<void> handleInitialParams() async {
    final params = Get.parameters;

    logger.log(label: "handleInitialParams", content: params.toString());

    if (params['data'] != null) {
      try {
        final String jsonDataString = params['data']!;
        final dynamic data = jsonDecode(jsonDataString);

        final asset = data['asset'];

        selectedToken.value = AssetBalance.fromJson(asset);
      } catch (e) {
        print("e: ${e.toString()}");
      }
    }
  }

  void _initializePaymentMethods() async {
    try {
      if (_financialController.paymentMethods.isEmpty) {
        await _financialController.initializePaymentMethods();
      }

      if (availablePaymentMethods.isNotEmpty) {
        getPaymentMethodDetails(availablePaymentMethods.value[0].id);
      }
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: '_initializePaymentMethods',
        reason: 'Error al obtener datos desde FinancialController.',
      );
    }
  }

  Future<void> chargeData() async {
    showLoading(context: Get.context!);

    await getAllTokens();

    dismissLoading(context: Get.context!);
  }

  Future<void> getAllTokens() async {
    await walletController.chargeAllBalances();

    tokens.assignAll(walletController.tokens);
  }

  void onInputChange() {
    isBlocked.value = true;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(_debounceDuration, () {
      if (buyFormKey.currentState!.validate() && selectedToken.value != null) {
        getBuyComission();
      }
    });
  }

  getBuyComission() async {
    if (selectedToken.value == null) return;

    showLoading();

    try {
      tesoreryAvailable = true;

      final ResponseApi res = await _walletRepository.getBuyCommision({
        "amount_tokens": receivableAmountController.text.toDouble(),
        "asset_code": selectedToken.value?.asset_code,
      });

      if (res.status == 'error') {
        final code = res.message_code ?? '';
        if (code == 'EDD_REQUIRED' || code == 'PENDING_ADDITIONAL_INFO') {
          _showKycLimitDialog();
        } else {
          DynamicToast.error(title: res.message ?? '');
          if (code == 'ONRAMP_INSUFFICIENT_TREASURY_TOKENS') {
            tesoreryAvailable = false;
          }
        }
        return;
      }

      final data = res.data;

      comission.value = data['fee_amount_usd'];

      rateConvertion.value = data['rate_usd'];

      payableAmountController.text = (data['amount_usd'] as double)
          .toHauvNumericString(decimals: 2);
    } catch (e) {
      print("Error en getBuyComission: $e");
    } finally {
      isBlocked.value = false;

      dismissLoading();
    }
  }

  updateSelectedToken(AssetBalance t) {
    try {
      selectedToken.value = t;

      Future.delayed(const Duration(milliseconds: 50), () {
        Get.toNamed(AppRoutes.BUY);
      });
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: "updateSelectedToken error",
      );
    }
  }

  void updateSelectedPaymentMethod(String value) {
    selectedPaymentMethodId.value = value;

    onInputChange();

    update();
  }

  //? buyViewForm

  void cleanForm() {
    receivableAmountController.clear();
    payableAmountController.clear();

    rateConvertion.value = 0;
    comission.value = 0;
  }

  void validateBuyForm() async {
    showLoading(context: Get.context!);

    if (!buyFormKey.currentState!.validate()) {
      dismissLoading();

      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    if (!await _minAmount()) {
      dismissLoading();

      DynamicToast.error(
        title: 'buy.buy_controller.snackbar_min_amount_title'.tr,
      );

      return;
    }

    if (!tesoreryAvailable) {
      dismissLoading();

      DynamicToast.error(
        title: 'buy.buy_controller.snackbar_insufficient_tokens_title'.tr,
      );

      return;
    }

    _submitBuyForm();
  }

  Future<bool> _minAmount() async {
    return (payableAmountController.text.toDouble() +
            comission.value.toDouble()) >
        10.0;
  }

  void _submitBuyForm() async {
    dismissLoading();

    Get.toNamed(AppRoutes.CONFIRM_BUY);
  }

  //? buyConfirmView — re-cotiza antes de avanzar para garantizar precio fresco
  void submitConfirmBuyForm() async {
    showLoading(context: Get.context!);
    await getBuyComission();
    dismissLoading(context: Get.context!);
    if (tesoreryAvailable) {
      Get.toNamed(AppRoutes.BUY_INFO);
    }
  }

  void _showKycLimitDialog() {
    final context = Get.context!;
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Operación no permitida',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(color: AppColors.light),
        ),
        content: Text(
          'Esta operación supera los límites de tu nivel de verificación. Para ampliar tus límites escríbenos a soporte@hauvtrading.com.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.light),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Entendido',
              style: textTheme.titleMedium?.copyWith(color: AppColors.main),
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyQuoteExpiredDialog() {
    final context = Get.context!;
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cotización vencida',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(color: AppColors.light),
        ),
        content: Text(
          'La cotización venció o ya no está disponible. Solicita una nueva cotización para continuar.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.light),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.BUY);
            },
            child: Text(
              'Nueva cotización',
              style: textTheme.titleMedium?.copyWith(color: AppColors.main),
            ),
          ),
        ],
      ),
    );
  }

  //? buyDataView
  void validateDataBuyForm() {
    showLoading(context: Get.context!);

    if (!buyFormKey.currentState!.validate()) {
      dismissLoading();

      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    _submitDataBuyForm();
  }

  void _submitDataBuyForm() async {
    final has2FA = await require2FAOrRedirect();
    if (!has2FA) return;
    await showTotpConfirmDialog(
      context: Get.context!,
      onConfirmed: () async {
        try {
          showLoading(showLoader: true);

          final ResponseApi res = await _walletRepository.excecuteBuy({
            "amount_tokens": receivableAmountController.text.toDouble(),
            "asset_code": selectedToken.value?.asset_code,
            "payment_method_id": selectedPaymentMethodId.value,
            "proof_payment": proofImageController.value,
            "payment_reference": proofController.text,
          });

          if (res.status != 'success' || res.data == null) {
            final code = res.message_code ?? '';
            if (code == 'EDD_REQUIRED' || code == 'PENDING_ADDITIONAL_INFO') {
              _showKycLimitDialog();
            } else if (code == 'TRANSACTION_QUOTATION_ERROR' ||
                code == 'INVALID_QUOTATION_DATA' ||
                code == 'QUOTE_EXPIRED') {
              _showBuyQuoteExpiredDialog();
            } else {
              DynamicToast.error(
                title: 'form.invalidForm_title'.tr,
                description: res.message,
              );
            }
            return;
          }

          final data = res.data as Map<String, dynamic>;

          Get.offAllNamed(
            AppRoutes.BUY_PENDING,
            arguments: {
              'asset_name': selectedToken.value?.asset_code ?? '',
              'amount_tokens': receivableAmountController.text,
              'amount_usd': payableAmountController.text,
              'transaction_id':
                  (data['id'] ?? data['transaction_id'] ?? '').toString(),
            },
          );
        } catch (e, s) {
          DynamicToast.error(
            title: 'buy.buy_controller.snackbar_unexpected_error_title'.tr,
            description: 'buy.buy_controller.snackbar_unexpected_error_message'.tr,
          );

          await logger.crashlyticsError(
            error: e,
            stackTrace: s,
            tag: '_submitDataBuyForm',
          );
        } finally {
          dismissLoading();
        }
      },
    );
  }

  getPaymentMethodDetails(String id) async {
    showLoading();

    selectedPaymentMethodId.value = id;

    await _financialController.fetchPaymentMethodDetailsByPaymentMethod(id);

    dismissLoading();
  }
}
