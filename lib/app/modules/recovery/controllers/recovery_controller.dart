import 'dart:async';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wiigold/app/routers/app_routes.dart';

import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/modules/recovery/repositories/recovery_repository.dart';

import 'package:wiigold/app/common/mixins/loading_mixin.dart';

import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';

import 'package:wiigold/app/common/directory/erros.dart';

class RecoveryController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RecoveryController");

  TextTheme textTheme = Theme.of(Get.context!).textTheme;
  final RecoveryRepository _recoveryRepository = RecoveryRepository();

  final recoveryFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final otpFormKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();

  final newPassFormKey = GlobalKey<FormState>();

  final TextEditingController newPassController1 = TextEditingController();
  final TextEditingController newPassController2 = TextEditingController();
  RxString timeToSendNewCode = '01:00'.obs;

  @override
  void onInit() async {
    super.onInit();

    _handleInitialParams();
  }

  void _handleInitialParams() {
    final params = Get.parameters;

    if (params['recoveryEmail'] != null) {
      emailController.text = "${params['recoveryEmail']}";
    }
  }

  void clearAllForm() {
    newPassController1.clear();
    newPassController2.clear();
    timeToSendNewCode.value = '01:00';
  }

  void validateRecoveryForm() {
    if (!recoveryFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    _submitRecoveryForm();
  }

  void _submitRecoveryForm() async {
    showLoading(context: Get.context!, showLoader: true);

    try {
      final ResponseApi res = await _getOtp();

      if (res.status == 'error') {
        await logger.crashlyticsReport(
          tag: '_submitRecoveryForm',
          reportMessage: res.message,
          customData: {
            'api_response': res.toString(),
            'api_message_code': res.message_code,
            'http_status_code': res.code,
          },
        );

        dismissLoading();

        DynamicToast.error(title: AppErrors.getErrorLabel(res.message));

        return;
      }

      startTimerToSendNewCode();

      otpController.text = '';

      Get.toNamed(AppRoutes.RECOVERY_VALIDATION);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'navigateRecoveryValidation',
      );

      DynamicToast.error(title: 'recovery.controller.error_title'.tr);
    } finally {
      dismissLoading();
    }
  }

  void startTimerToSendNewCode() {
    int timeStringToSeconds(String time) {
      List<String> parts = time.split(':');
      int minutes = int.parse(parts[0]);
      int seconds = int.parse(parts[1]);
      return minutes * 60 + seconds;
    }

    String secondsToTimeString(int seconds) {
      int minutes = (seconds ~/ 60);
      int remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    int totalSeconds = timeStringToSeconds(timeToSendNewCode.value);

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (totalSeconds > 0) {
        totalSeconds--;
        timeToSendNewCode.value = secondsToTimeString(totalSeconds);
      } else {
        timer.cancel();
      }
    });
  }

  void validateOtpForm() {
    if (!recoveryFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    _submitValidateOtpForm();
  }

  _submitValidateOtpForm() async {
    showLoading(context: Get.context!, showLoader: true);

    try {
      final ResponseApi res = await _recoveryRepository.verifyOtp(
        email: emailController.text,
        otp: otpController.text,
      );

      if (res.status == 'error') {
        await logger.crashlyticsReport(
          tag: '_submitRecoveryForm',
          reportMessage: res.message,
          customData: {
            'api_response': res.toString(),
            'api_message_code': res.message_code,
            'http_status_code': res.code,
          },
        );

        dismissLoading();

        print("AppErrors.getErrorLabel(res.message) ${AppErrors.getErrorLabel(res.message_code)}");

        DynamicToast.error(title: AppErrors.getErrorLabel(res.message_code));

        return;
      }

      Get.toNamed(AppRoutes.RECOVERY_NEWPASS);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'navigateRecoveryValidation',
      );

      DynamicToast.error(title: 'recovery.controller.error_title'.tr);
    } finally {
      dismissLoading();
    }
  }

  void resendCode() async {
    if (timeToSendNewCode.value != '00:00') {
      DynamicToast.error(
        title: 'recovery.controller.resend_wait_title'.tr,
        description: 'recovery.controller.resend_wait_description'.tr,
      );

      return;
    }

    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _getOtp();

      if (res.status == 'error') {
        await logger.crashlyticsReport(
          tag: 'resendCode',
          reportMessage: res.message,
          customData: {
            'api_response': res.toString(),
            'api_message_code': res.message_code,
            'http_status_code': res.code,
          },
        );

        dismissLoading();

        DynamicToast.error(title: AppErrors.getErrorLabel(res.message));

        return;
      }

      timeToSendNewCode.value = '01:00';
      startTimerToSendNewCode();

      DynamicToast.info(title: 'recovery.controller.resend_success_message'.tr);
    } catch (e, s) {
      await logger.crashlyticsError(error: e, stackTrace: s, tag: 'resendCode');

      DynamicToast.error(title: 'recovery.controller.error_title'.tr);
    } finally {
      dismissLoading();
    }
  }

  void validateNewPassForm() {
    if (!newPassFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    if (newPassController1.text != newPassController2.text) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'recovery.controller.passwords_do_not_match'.tr,
      );

      return;
    }

    _validateNewPassForm();
  }

  _validateNewPassForm() async {
    showLoading(context: Get.context!, showLoader: true);

    try {
      final ResponseApi res = await _recoveryRepository.changePassword(
        email: emailController.text,
        newpassword: newPassController1.text,
        otp: otpController.text,
      );

      if (res.status == 'error') {
        await logger.crashlyticsReport(
          tag: '_validateNewPassForm',
          reportMessage: res.message,
          customData: {
            'api_response': res.toString(),
            'api_message_code': res.message_code,
            'http_status_code': res.code,
          },
        );

        dismissLoading();

        DynamicToast.error(title: AppErrors.getErrorLabel(res.message));

        return;
      }

      DynamicToast.success(
        title: 'recovery.controller.password_recovered_success'.tr,
      );

      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: '_validateNewPassForm',
      );

      DynamicToast.error(title: 'recovery.controller.error_title'.tr);
    } finally {
      dismissLoading();
    }
  }

  Future<ResponseApi> _getOtp() async {
    return await _recoveryRepository.requestOtp(email: emailController.text);
  }
}
