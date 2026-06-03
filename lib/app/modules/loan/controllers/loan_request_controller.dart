import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/data/models/request/loan_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/loan/repositories/loan_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? REPOSITORIES

//? MODELS

//? MIXINS

//? THEME & IMAGES

//? WIDGETS

//? Others

class LoanRequestController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "LoanRequestController");

  final LoanRepository _loanRepository = LoanRepository();
  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  final WalletController walletController = Get.find<WalletController>();

  final amountLoanRequestFormKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController(
    text: "",
  );

  RxList<AssetBalance> tokens = <AssetBalance>[].obs;
  final Rx<AssetBalance?> selectedToken = Rx(null);

  final RxString availableBalance = '0'.obs;
  RxString goldBalance = '0'.obs;
  RxString usdBalance = '0'.obs;

  RxString usdLimit = '0'.obs;
  final RxDouble collateralAmount = 0.0.obs;

  RxBool checkTerms = false.obs;

  Timer? _debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 700);

  final RxBool isBlocked = false.obs;

  @override
  void onInit() async {
    super.onInit();

    handleInitialParams();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();

    super.onClose();
  }

  handleInitialParams() async {
    final params = Get.parameters;

    logger.log(label: "Initial params: $params");

    if (params['data'] != null) {
      showLoading();

      final String jsonDataString = params['data']!;
      final dynamic data = jsonDecode(jsonDataString);

      await getAllTokens();

      selectedToken.value = tokens.firstWhere(
        (t) => t.asset_code == data['codeAsset'],
      );

      getLoanData();

      logger.log(
        label: "data['amountUsd'].toString() ${data['amountUsd'].toString()}",
      );

      amountController.text = data['amountUsd'].toString();
      onAmountChanged(data['amountUsd'].toString());

      dismissLoading();
    }
  }

  Future<void> chargeData() async {
    showLoading(context: Get.context!);

    try {
      getAllTokens();
    } catch (e) {
      print("e: ${e.toString()}");
    } finally {
      dismissLoading();
    }
  }

  Future<void> getAllTokens() async {
    showLoading();

    await walletController.chargeAllBalances();

    tokens.assignAll(walletController.tokens);

    dismissLoading();
  }

  Future<void> getLoanData() async {
    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _loanRepository.loanData(
        selectedToken.value?.asset_code ?? '',
      );

      if (res.status == 'error') {
        DynamicToast.error(
          title: res.message ?? 'loan.request_controller.unexpected_error'.tr,
        );

        return;
      }

      if (res.data == null || res.data is! Map<String, dynamic>) {
        DynamicToast.error(
          title: 'loan.request_controller.invalid_server_response'.tr,
        );
        return;
      }

      final Map<String, dynamic> data = res.data;

      final rawTokens = data['total_tokens'];
      availableBalance.value =
          rawTokens?.toString().toHauvNumericString() ?? '';

      final rawGrams = data['total_grams'];
      goldBalance.value = rawGrams?.toString().toHauvNumericString() ?? '';

      final rawUsd = data['total_usd'];
      usdBalance.value =
          rawUsd?.toString().toHauvNumericString(decimals: 2) ?? '';

      final rawLimit = data['max_loan_usd'];
      usdLimit.value =
          rawLimit?.toString().toHauvNumericString(decimals: 2) ?? '';
    } catch (e) {
      DynamicToast.error(title: 'loan.request_controller.load_info_error'.tr);
    } finally {
      dismissLoading();
    }
  }

  void onAmountChanged(String value) {
    isBlocked.value = true;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(_debounceDuration, () {
      if (amountLoanRequestFormKey.currentState!.validate()) {
        calculateCollateral();
      }
    });
  }

  void calculateCollateral() async {
    try {
      final amountText = amountController.text.trim();

      if (amountText.isEmpty) {
        collateralAmount.value = 0.0;
        return;
      }

      ResponseApi res = await _loanRepository.getCollateral({
        "amount": amountController.text.toDouble(),
        "code_asset": selectedToken.value?.asset_code ?? '',
      });

      final data = res.data;

      if (res.status == 'success') {
        collateralAmount.value = (data['required_tokens'] as double);
      } else {
        collateralAmount.value = 0.0;
      }
    } catch (e) {
      print("e: ${e.toString()}");
    } finally {
      isBlocked.value = false;
    }
  }

  updateSelectedToken(AssetBalance t) {
    try {
      selectedToken.value = t;

      if ((selectedToken.value?.available?.toDouble() ?? 0.0) <= 0) {
        dismissLoading();

        DynamicToast.error(title: 'send.controller.amount_not_available'.tr);

        return;
      }

      getLoanData();

      Future.delayed(const Duration(milliseconds: 50), () {
        Get.toNamed(AppRoutes.LOAN_REQUEST);
      });
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: "updateSelectedToken error",
      );
    }
  }

  Future<void> validateInsetAmountForm() async {
    showLoading(context: Get.context!);

    if (!amountLoanRequestFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      dismissLoading();

      return;
    }

    if (!_amountAvilable()) {
      DynamicToast.error(
        title: 'loan.request_controller.insufficient_funds'.tr,
      );

      dismissLoading();

      return;
    }

    _submitInsetAmountForm();
  }

  bool _amountAvilable() {
    return collateralAmount.value <= availableBalance.value.toDouble();
  }

  void _submitInsetAmountForm() {
    dismissLoading();

    Get.toNamed(
      AppRoutes.LOAN_DATA,
      parameters: {
        "data": LoanData(
          amountUsd: amountController.text.toDouble(),
          codeAsset: selectedToken.value?.asset_code ?? '',
        ).toJsonEncode(),
      },
    );
  }
}
