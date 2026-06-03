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
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/common/widgets/layout/totp_confirm_dialog.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/config/environment.dart';

//? REPOSITORIES

//? THEME & IMAGES

//? MIXINS

//? WIDGETS

//? MODELS

//? OTHERS

class ExchangeController extends GetxController
    with LoadingMixin, TransactionsClusterMixin {
  final Logger logger = Logger(module: "ExhangeController");

  final WalletRepository _walletRepository = WalletRepository();

  final WalletController walletController = Get.find<WalletController>();

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  Timer? _debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 700);

  final RxBool isBlocked = false.obs;

  final exchangeFormKey = GlobalKey<FormState>();

  RxList<AssetBalance> tokens = <AssetBalance>[].obs;

  final Rx<AssetBalance?> selectedTokenFrom = Rx(null);
  final Rx<AssetBalance?> selectedTokenTo = Rx(null);

  final fromAmountController = TextEditingController(text: '');
  final toAmountController = TextEditingController(text: '');

  final RxDouble rateConvertion = 0.0.obs;
  final RxDouble valueConvertion = 0.0.obs;
  final RxDouble comission = 0.0.obs;

  final bankController = TextEditingController(text: 'opt1');
  final typeDocumentController = TextEditingController(text: 'opt1');
  final nroDocumentController = TextEditingController(text: '');
  final typeAccountController = TextEditingController(text: 'opt1');
  final nroAccountController = TextEditingController(text: '');

  @override
  void onInit() async {
    super.onInit();

    chargeData();
  }

  Future<void> chargeData() async {
    showLoading(context: Get.context!);

    await getAllTokens();

    _handleInitialParams();

    dismissLoading(context: Get.context!);
  }

  _handleInitialParams() {
    if (Get.arguments == null || Get.arguments is! Map<String, dynamic>) {
      return;
    }

    final args = Get.arguments;

    if (args['viewMode'] == 'ofTokenView') {
      final dynamic data = jsonDecode(args['data']) as Map<String, dynamic>;

      if (data['curr'] != null && data['curr'].toString().isNotEmpty) {
        final urlToken = tokens.firstWhere(
          (token) => token.asset_code == data['curr'].toString(),
          orElse: () {
            logger.log(
              label: "DeepLink Warning",
              content: "Token from URL not found, defaulting to first token.",
            );
            return tokens.first;
          },
        );

        selectedTokenFrom.value = urlToken;
      } else {
        Get.toNamed(AppRoutes.SEND_SELECTOR);
      }
    }
  }

  Future<void> getAllTokens() async {
    await walletController.chargeAllBalances();

    tokens.assignAll(walletController.tokens);

    _resetConversionValues();

    final bool shouldRecalculate = selectedTokenTo.value != null;

    _updateSelectedTokens();

    if (shouldRecalculate) {
      if (selectedTokenTo.value != null) {
        onInputChange();
      }
    }
  }

  void _resetConversionValues() {
    rateConvertion.value = 0.0;
    valueConvertion.value = 0.0;
    comission.value = 0.0;
  }

  void _updateSelectedTokens() {
    AssetBalance? findToken(String? assetCode) {
      if (assetCode == null) return null;
      return tokens.firstWhereOrNull((token) => token.asset_code == assetCode);
    }

    final fromCode = selectedTokenFrom.value?.asset_code;
    selectedTokenFrom.value =
        findToken(fromCode) ?? findToken(EnvironmentConfig.goldToken);

    final toCode = selectedTokenTo.value?.asset_code;
    selectedTokenTo.value = findToken(toCode);
  }

  void onInputChange() {
    isBlocked.value = true;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(_debounceDuration, () {
      if (fromAmountController.text.toDouble() <= 0) return;

      if (exchangeFormKey.currentState!.validate() &&
          selectedTokenFrom.value != null &&
          selectedTokenTo.value != null) {
        getExchangeComission();
      }
    });
  }

  getExchangeComission() async {
    if (selectedTokenFrom.value == null || selectedTokenTo.value == null) {
      return;
    }

    showLoading();

    try {
      final ResponseApi res = await _walletRepository.getExchangeCommision({
        "amount_from": fromAmountController.text.toDouble(),
        "code_asset_from": selectedTokenFrom.value!.asset_code,
        "code_asset_to": selectedTokenTo.value!.asset_code,
      });

      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? '');
        return;
      }

      final data = res.data;

      comission.value = data['fee_amount'];
      valueConvertion.value = data['amount_usd'];
      rateConvertion.value = data['rate'];

      toAmountController.text = (data['amount_to'] as double)
          .toHauvNumericString();
    } catch (e) {
      print("Error en getExchangeComission: $e");
    } finally {
      dismissLoading();

      isBlocked.value = false;
    }
  }

  void validateExchangeForm() async {
    showLoading(context: Get.context!);

    if (exchangeFormKey.currentState!.validate() &&
        selectedTokenFrom.value != null &&
        selectedTokenTo.value != null) {
      dismissLoading();

      _submitExchangeForm();
    } else {
      dismissLoading();

      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );
    }
  }

  void _submitExchangeForm() async {
    Get.toNamed(AppRoutes.EXCHANGE_CONFIRM);
  }

  void submitConfirmExchangeForm() async {
    if (selectedTokenFrom.value == null || selectedTokenTo.value == null) {
      return;
    }

    final has2FA = await require2FAOrRedirect();
    if (!has2FA) return;
    await showTotpConfirmDialog(
      context: Get.context!,
      onConfirmed: () async {
        try {
          showLoading(showLoader: true);

          final ResponseApi res = await _walletRepository.excecuteExchange({
            "amount_from": fromAmountController.text.toDouble(),
            "code_asset_from": selectedTokenFrom.value!.asset_code,
            "code_asset_to": selectedTokenTo.value!.asset_code,
          });

          if (res.status != 'success' || res.data == null) {
            DynamicToast.error(
              title: res.message ?? 'Ocurrió un error inesperado.',
            );
            return;
          }

          final Map<String, dynamic> payload = {
            'apiResponse': res.data as Map<String, dynamic>,
          };

          redirectToTransaction(payload);
        } catch (e) {
          print("Error en submitConfirmExchangeForm: $e");

          DynamicToast.error(title: 'Ocurrió una excepción al procesar el cambio.');
        } finally {
          dismissLoading();
        }
      },
    );
  }
}
