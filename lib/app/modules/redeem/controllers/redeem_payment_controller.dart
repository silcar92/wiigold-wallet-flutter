import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/services/biometric_service.dart';
import 'package:wiigold/app/modules/redeem/repositories/redeem_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? REPOSITORIES

//? MODELS

//? MIXINS

//? THEME & IMAGES

//? WIDGETS

class RedeemPaymentController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RedeemPaymentController");

  final RedeemRepository _redeemRepository = RedeemRepository();
  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  final BiometricService _biometricService = Get.find<BiometricService>();

  RxBool inAmountForm = true.obs;

  RxString redeemReference = ''.obs;

  final paymentAmountFormKey = GlobalKey<FormState>();
  final paymentMethodFormKey = GlobalKey<FormState>();

  RxDouble remainingAmount = 0.0.obs;
  final TextEditingController amountController = TextEditingController(
    text: "",
  );

  final ValueNotifier<String?> proofImageController = ValueNotifier(null);

  final TextEditingController paymentDateController = TextEditingController(
    text: "",
  );

  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController proofController = TextEditingController(text: "");

  @override
  void onInit() async {
    super.onInit();

    _handleInitialParams();
  }

  @override
  void onClose() {
    super.onClose();
    proofController.dispose();
  }

  _handleInitialParams() {
    final params = Get.parameters;

    if (params['data'] != null) {
      final String jsonDataString = params['data']!;
      final dynamic data = jsonDecode(jsonDataString);

      if (data['amount'] != null) {
        remainingAmount.value = data['amount'];
      }

      if (data['redeem_reference'] != null) {
        redeemReference.value = data['redeem_reference'];
      }
    }
  }

  void validatePaymentAmountForm() async {
    if (!paymentAmountFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    _submitPaymentAmountForm();
  }

  setAllAmount() {
    amountController.text = remainingAmount.value.toHauvNumericString();
  }

  _submitPaymentAmountForm() {
    inAmountForm.value = false;
  }

  void validatePaymentMethodForm() async {
    showLoading(context: Get.context!);

    if (!paymentMethodFormKey.currentState!.validate()) {
      dismissLoading();

      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    _submitRedeemPaymentForm();
  }

  _submitRedeemPaymentForm() async {
    final isAuthenticated = await _biometricService.authenticate(
      reason: 'redeem.payment_controller.biometric_reason'.tr,
    );

    if (!isAuthenticated) {
      DynamicToast.error(
        title: 'redeem.payment_controller.biometric_cancelled_title'.tr,
        description:
            'redeem.payment_controller.biometric_cancelled_description'.tr,
      );

      dismissLoading();

      return;
    }

    try {
      ResponseApi res = await _redeemRepository.setRedeemPayment({
        "redeem_reference": redeemReference.value,
        "amount_usd": amountController.text.toDouble(),
        "payment_reference": proofController.text,
        "payment_date": paymentDateController.text,
        "email_user": emailController.text,
        "proof_payment": proofImageController.value,
      });

      if (res.status == 'error') {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'form.invalidForm_error'.trParams({
            'message': res.message.toString(),
          }),
        );

        return;
      }

      DynamicToast.success(
        title: 'redeem.payment_controller.payment_successful'.tr,
      );

      dismissLoading();

      Get.offAllNamed(
        AppRoutes.REDEEM_DETAIL,
        parameters: {
          "data": jsonEncode({"redeem_reference": redeemReference.value}),
        },
      );
    } catch (e) {
      print('e: ${e.toString()}');
    } finally {
      dismissLoading();
    }
  }
}
