import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/data/models/request/login_model.dart';
import 'package:wiigold/app/data/models/request/register_model.dart';
import 'package:wiigold/app/modules/login/respositories/login_repository.dart';
import 'package:wiigold/app/modules/register/repositories/register_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

class RegisterController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RegisterController");
  late final TextTheme textTheme;
  final LoginRepository _loginRepository = LoginRepository();
  final RegisterRepository _registerRepository = RegisterRepository();

  static const String _currentTosVersion = '1.0';
  static const String _currentPrivacyVersion = '1.0';

  late Register registerRequest;

  final registerFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool checkTerms = false.obs;
  RxBool checkPrivacy = false.obs;

  final RxBool finishVerification = false.obs;
  final RxBool acceptTerms = false.obs;

  final RxString selectedPersonType = 'natural'.obs;
  final RxBool hasMadeSelection = true.obs;

  RegisterController() {
    textTheme = Theme.of(Get.context!).textTheme;
  }

  @override
  void onInit() {
    super.onInit();

    _handleParams();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _handleParams() {
    final params = Get.parameters;
    if (params['registerRequest'] != null) {
      registerRequest = Register.fromJson(
        jsonDecode(params['registerRequest']!),
      );

      emailController.text = registerRequest.email ?? '';
    } else {
      registerRequest = Register();
    }
  }

  Future<void> validateRegisterForm() async {
    if (!registerFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );
      return;
    }

    showLoading(showLoader: true);

    try {
      //? email avaible
      final responseEmail = await _loginRepository.avilableEmail(
        emailController.text.toLowerCase(),
      );

      if (responseEmail.status == 'error') {
        await logger.crashlyticsReport(
          tag: 'registerEmailFailure',
          reportMessage: responseEmail.message,
        );

        DynamicToast.error(
          title: AppErrors.getErrorLabel(responseEmail.message),
        );

        dismissLoading();

        return;
      }

      if (responseEmail.message_code != 'EMAIL_AVAILABLE') {
        DynamicToast.error(
          title: AppErrors.getErrorLabel("EMAIL_UNAVAILABLE_REGISTER"),
        );

        dismissLoading();

        return;
      }

      registerRequest = Register(email: emailController.text.toLowerCase());

      //? register request
      final finalRequest = registerRequest.copyWith(
        password: passwordController.text,
        tosVersion: checkTerms.value ? _currentTosVersion : null,
        privacyVersion: checkPrivacy.value ? _currentPrivacyVersion : null,
        personType: selectedPersonType.value,
      );

      final responseRegister = await _registerRepository.register(finalRequest);

      if (responseRegister.status == 'error') {
        await logger.crashlyticsReport(
          tag: 'registerPassFailure',
          reportMessage: responseRegister.message,
        );

        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: responseRegister.message,
        );

        dismissLoading();

        return;
      }

      //? navigation
      _toEmailVerification();
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'registerFlowError',
        reason: 'Error inesperado durante el flujo de registro.',
      );

      DynamicToast.error(title: "Crash error in _validateAndSubmit");
    } finally {
      dismissLoading();
    }
  }

  void _toEmailVerification() async {
    try {
      Get.toNamed(
        AppRoutes.REGISTER_VERIFICATION,
        parameters: {
          "registerRequest": Login(
            email: registerRequest.email?.toLowerCase(),
            password: passwordController.text,
          ).toJsonEncode(),
        },
      );
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'navigateEmailVerification',
      );
    } finally {
      dismissLoading();
    }
  }

  void selectPersonType(String type) {
    selectedPersonType.value = type;
    hasMadeSelection.value = true;
  }

  void continueFromTypeSelector() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }
}
