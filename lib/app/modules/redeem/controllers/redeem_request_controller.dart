import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/redeem/repositories/redeem_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? REPOSITORIES

//? MODELS

//? MIXINS

//? THEME & IMAGES

//? WIDGETS

//? Others

class RedeemRequestController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RedeemRequestController");

  final WalletRepository _walletRepository = WalletRepository();
  final RedeemRepository _redeemRepository = RedeemRepository();
  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  final amountRedeemRequestFormKey = GlobalKey<FormState>();

  final TextEditingController quantityController = TextEditingController(
    text: "",
  );

  final RxString availableBalance = '0'.obs;
  RxString mineralBalance = '0'.obs;
  RxString usdBalance = '0'.obs;

  RxString tokenLimit = '0'.obs;
  final RxDouble comissionAmount = 0.0.obs;

  RxBool checkTerms = false.obs;

  Timer? _debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 700);

  final RxBool isBlocked = false.obs;

  late final AssetBalance t;
  final Rx<AssetBalance?> selectedToken = Rx(null);
  RxList<AssetBalance> tokens = <AssetBalance>[].obs;

  @override
  void onInit() async {
    super.onInit();

    _handleInitialParams();

    await chargeData();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();

    super.onClose();
  }

  _handleInitialParams() {
    final params = Get.parameters;

    if (params['data'] != null) {
      try {
        final String jsonDataString = params['data']!;
        final dynamic data = jsonDecode(jsonDataString);

        final asset = data['asset'];

        t = AssetBalance.fromJson(asset);

        selectedToken.value = t;

        logger.log(
          label: "selectedToken.value",
          content: selectedToken.value.toString(),
        );

        tokens.assignAll([t]);
      } catch (e) {
        print("e: ${e.toString()}");
      }
    }
  }

  Future<void> chargeData() async {
    showLoading(context: Get.context!);

    try {
      availableBalance.value =
          selectedToken.value?.available?.toHauvNumericString() ?? '';
      mineralBalance.value =
          selectedToken.value?.available?.toHauvNumericString(decimals: 2) ??
          '';
      usdBalance.value =
          ((selectedToken.value?.asset_info?.rateChange?.currentRate
                          ?.toDouble() ??
                      0.0) *
                  (selectedToken.value?.available?.toDouble() ?? 0.0))
              .toHauvNumericString(decimals: 2);

      tokenLimit.value =
          selectedToken.value?.available?.toHauvNumericString(decimals: 2) ??
          '';
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'RedeemRequestController - chargeData',
      );
    } finally {
      dismissLoading();
    }
  }

  Future<void> getTokenBalance() async {
    try {
      final ResponseApi res = await _walletRepository.getTokenBalance(
        t.asset_code!,
      );

      if (res.status == 'error') {
        tokens.clear();

        return;
      }

      if (res.data == null || res.data is! Map<String, dynamic>) {
        tokens.clear();
        return;
      }

      final Map<String, dynamic> responseData =
          res.data as Map<String, dynamic>;

      if (!responseData.containsKey('balances') ||
          responseData['balances'] is! List) {
        tokens.clear();
        return;
      }

      final List<dynamic> balancesJsonList =
          responseData['balances'] as List<dynamic>;

      List<AssetBalance> fetchedBalances = balancesJsonList
          .map((jsonItem) {
            if (jsonItem is Map<String, dynamic>) {
              try {
                return AssetBalance.fromJson(jsonItem);
              } catch (e) {
                print("Error parsing AssetBalance: $e, item: $jsonItem");
                return null;
              }
            }
            return null;
          })
          .whereType<AssetBalance>()
          .toList();

      tokens.assignAll(fetchedBalances);

      selectedToken.value = tokens.value[0];
    } catch (e) {
      print("Error en getAllTokens: $e");
      tokens.clear();
    } finally {
      dismissLoading();
    }
  }

  void onAmountChanged(String value) {
    isBlocked.value = true;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(_debounceDuration, () {
      if (amountRedeemRequestFormKey.currentState!.validate()) {
        calculateRedeem();
      }
    });
  }

  void calculateRedeem() async {
    try {
      final amountText = quantityController.text.trim();

      if (amountText.isEmpty) {
        comissionAmount.value = 0.0;
        return;
      }

      ResponseApi res = await _redeemRepository.getCalculate({
        "quantity_requested": quantityController.text.toDouble(),
        "asset_code": selectedToken.value?.asset_code,
      });

      final data = res.data;

      if (res.status == 'error') {
        DynamicToast.error(
          title:
              {
                "INSUFFICIENT_BALANCE":
                    'redeem.request_controller.insufficient_balance_error'.tr,
              }[res.message_code] ??
              'redeem.request_controller.unknown_error'.tr,
        );

        comissionAmount.value = 0.0;

        return;
      }

      comissionAmount.value = (data['fee_amount'] as double);
    } catch (e) {
      print("e: ${e.toString()}");
    } finally {
      isBlocked.value = false;
    }
  }

  Future<void> validateInsetAmountForm() async {
    showLoading(context: Get.context!);

    if (!amountRedeemRequestFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      dismissLoading();

      return;
    }

    if (!_amountAvilable()) {
      DynamicToast.error(
        title: 'redeem.request_controller.insufficient_funds_error'.tr,
      );

      dismissLoading();

      return;
    }

    _submitInsetAmountForm();
  }

  bool _amountAvilable() {
    return comissionAmount.value + quantityController.text.toDouble() <=
            availableBalance.value.toDouble() &&
        comissionAmount.value != 0.0;
  }

  void _submitInsetAmountForm() {
    dismissLoading();

    Get.toNamed(
      AppRoutes.REDEEM_DATA,
      parameters: {
        "data": jsonEncode({
          "asset": selectedToken.toJson(),
          "quantity": quantityController.text,
        }),
      },
    );
  }
}
