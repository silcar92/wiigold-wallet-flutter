import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/mixins/transactions_cluster_mixin.dart';
import 'package:wiigold/app/common/utils/banks.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/common/widgets/layout/totp_confirm_dialog.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? THEME & IMAGES

//? MIXINS

//? WIDGETS

//? UTILS

class SellController extends GetxController
    with LoadingMixin, TransactionsClusterMixin {
  final Logger logger = Logger(module: "SellController");

  final WalletRepository _walletRepository = WalletRepository();

  final WalletController walletController = Get.find<WalletController>();

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  Timer? _debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 700);

  Timer? _quoteTimer;
  final RxInt quoteTtl = 0.obs;
  static const int _quoteDuration = 60;

  final RxBool isBlocked = true.obs;

  void clearAllForm() {
    soldAmountController.clear();
    payableAmountController.clear();
  }

  //? sellViewForm
  final sellFormKey = GlobalKey<FormState>();

  final soldAmountController = TextEditingController(text: '');
  final payableAmountController = TextEditingController(text: '');

  final sellDataFormKey = GlobalKey<FormState>();

  final RxString currencyTarget = 'usd'.obs;

  final Rx<AssetBalance?> selectedToken = Rx(null);
  RxList<AssetBalance> tokens = <AssetBalance>[].obs;

  final RxDouble rateConvertion = 0.0.obs;
  final RxDouble comission = 0.0.obs;

  //? sellViewForm
  final TextEditingController accountNameController = TextEditingController(
    text: '',
  );

  final TextEditingController accountNumberController = TextEditingController(
    text: '',
  );

  final TextEditingController bankNameController = TextEditingController(
    text: '',
  );

  final RxString bankName = ''.obs;

  final TextEditingController swiftCodeController = TextEditingController(
    text: '',
  );

  final typeDocumentController = TextEditingController(text: 'DNI');

  final RxString typeDocument = 'DNI'.obs;

  final nroDocumentController = TextEditingController(text: '');

  @override
  void onInit() async {
    super.onInit();

    chargeData();

    _handleInitialParams();
  }

  _handleInitialParams() {
    final params = Get.parameters;

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

  Future<void> chargeData() async {
    showLoading(context: Get.context!);

    await getAllTokens();

    dismissLoading();
  }

  Future<void> getAllTokens() async {
    await walletController.chargeAllBalances();

    tokens.assignAll(walletController.tokens);
  }

  void onInputChange() {
    isBlocked.value = true;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(_debounceDuration, () {
      if (sellFormKey.currentState!.validate() && selectedToken.value != null) {
        getSellComission();
      }
    });
  }

  updateSelectedToken(AssetBalance t) {
    try {
      selectedToken.value = t;

      if ((selectedToken.value?.available?.toDouble() ?? 0.0) <= 0) {
        dismissLoading();

        DynamicToast.error(title: 'send.controller.amount_not_available'.tr);

        return;
      }

      Future.delayed(const Duration(milliseconds: 50), () {
        Get.toNamed(AppRoutes.SELL);
      });
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: "updateSelectedToken error",
      );
    }
  }

  getSellComission() async {
    if (selectedToken.value == null) return;

    showLoading();

    try {
      final ResponseApi res = await _walletRepository.getSellCommision({
        "amount_tokens": soldAmountController.text.toDouble(),
        "asset_code": selectedToken.value?.asset_code,
      });

      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? '');
        return;
      }

      final data = res.data;

      comission.value = data['fee_amount_tokens'].toString().toDouble();

      rateConvertion.value = data['rate_usd'].toString().toDouble();

      payableAmountController.text = data['amount_usd']
          .toString()
          .toDouble()
          .toHauvNumericString();

      isBlocked.value = false;
      _startQuoteTimer();
    } catch (e) {
      print("Error en getSellComission: $e");
    } finally {
      dismissLoading();
    }
  }

  void _startQuoteTimer() {
    _quoteTimer?.cancel();
    quoteTtl.value = _quoteDuration;
    _quoteTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (quoteTtl.value <= 1) {
        t.cancel();
        quoteTtl.value = 0;
        getSellComission();
      } else {
        quoteTtl.value--;
      }
    });
  }

  void _showQuoteExpiredDialog() {
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
              Get.offAllNamed(AppRoutes.SELL);
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

  @override
  void onClose() {
    _quoteTimer?.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }

  //? sellDataViewForm
  void validateSellForm() async {
    showLoading(context: Get.context!);

    try {
      if (!await _amountAvilable()) {
        dismissLoading();

        DynamicToast.error(title: 'Monto no disponible');

        return;
      }

      if (!sellFormKey.currentState!.validate()) {
        dismissLoading();

        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'form.invalidForm_message'.tr,
        );

        return;
      }

      dismissLoading();

      _submitSellForm();
    } catch (e) {
      print("e: ${e.toString()}");
    }
  }

  Future<bool> _amountAvilable() async {
    return (soldAmountController.text.toDouble() +
            comission.value.toDouble()) <=
        selectedToken.value!.available!.toDouble();
  }

  void _submitSellForm() async {
    Get.toNamed(AppRoutes.SELL_DATA);
  }

  //? sellDataViewForm
  changeSwiftCode(String value) {
    value = value.trim();

    if (getBankBySwiftCode(value) != null) {
      bankName.value = getBankBySwiftCode(value.trim())!.bankName;

      bankNameController.text = bankName.value;
    } else {
      bankName.value = '';
      bankNameController.text = '';
    }
  }

  void updateSelectedTypeDocument(String value) {
    typeDocument.value = value;

    update();
  }

  void validateDataSellForm() {
    showLoading(context: Get.context!);

    if (!sellFormKey.currentState!.validate()) {
      dismissLoading();

      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    _submitDataSellForm();
  }

  void _submitDataSellForm() async {
    dismissLoading();
    // Re-cotiza antes de CONFIRM_SELL para garantizar precio fresco
    await getSellComission();
    if (!isBlocked.value) {
      Get.toNamed(AppRoutes.CONFIRM_SELL);
    }
  }

  //? confirm sell
  void validateConfirmSell() async {
    try {
      _submitConfirmSell();
    } catch (e) {
      print("error: $e");

      dismissLoading();
    }
  }

  _submitConfirmSell() async {
    final has2FA = await require2FAOrRedirect();
    if (!has2FA) return;
    await showTotpConfirmDialog(
      context: Get.context!,
      onConfirmed: () async {
        try {
          showLoading(showLoader: true);

          final ResponseApi res = await _walletRepository.excecuteSell({
            "amount_tokens": soldAmountController.text.toDouble(),
            "asset_code": selectedToken.value?.asset_code,
            "swift_code": swiftCodeController.text,
            "account_number": accountNumberController.text,
            "full_name": accountNameController.text,
            "document_type": typeDocument.value,
            "document_number": nroDocumentController.text,
          });

          if (res.status != 'success' || res.data == null) {
            final code = res.message_code ?? '';
            if (code == 'TRANSACTION_QUOTATION_ERROR' ||
                code == 'INVALID_QUOTATION_DATA' ||
                code == 'QUOTE_EXPIRED') {
              _showQuoteExpiredDialog();
            } else {
              DynamicToast.error(
                title: 'form.invalidForm_title'.tr,
                description: res.message,
              );
            }
            return;
          }

          final Map<String, dynamic> payload = {
            'apiResponse': res.data as Map<String, dynamic>,
          };

          redirectToTransaction(payload);
        } catch (e, s) {
          DynamicToast.error(
            title: 'Error Inesperado',
            description: 'Ocurrió un error al procesar la transacción.',
          );

          await logger.crashlyticsError(
            error: e,
            stackTrace: s,
            tag: '_submitConfirmSell',
          );
        } finally {
          dismissLoading();
        }
      },
    );
  }
}
