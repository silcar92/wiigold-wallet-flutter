import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? Firebase
import 'package:firebase_messaging/firebase_messaging.dart';

//? Models
import 'package:wiigold/app/data/models/request/login_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';

//? Repositories
import 'package:wiigold/app/modules/login/respositories/login_repository.dart';

//? Mixins
import 'package:wiigold/app/common/mixins/loading_mixin.dart';

//? others
import 'package:wiigold/app/common/utils/logger.dart';

class LoginController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "LoginController");
  final LoginRepository _loginRepository = LoginRepository();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final RxBool hasError = false.obs;
  final RxBool isAccountLocked = false.obs;
  final RxString loginError = ''.obs;

  final RxString email = ''.obs;

  final loginFormKey = GlobalKey<FormState>();
  final passLoginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passController.dispose();
    super.onClose();
  }

  void clearAllForms() {
    emailController.clear();
    passController.clear();
  }

  void validateLoginForm() async {
    loginError.value = '';
    isAccountLocked.value = false;
    showLoading(context: Get.context!, showLoader: true);

    //> Validate form
    if (!loginFormKey.currentState!.validate()) {
      dismissLoading();

      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    //> Validate email available
    final ResponseApi res = await _loginRepository.avilableEmail(
      emailController.text.toLowerCase(),
    );

    if (res.status == 'error') {
      hasError.value = true;
      dismissLoading();
      loginError.value = AppErrors.getErrorLabel(res.message);
      logger.crashlyticsReport(
        tag: 'loginEmailFailure',
        reportMessage: res.message,
        customData: {
          'api_response': res.toString(),
          'api_message_code': res.message_code,
          'http_status_code': res.code,
        },
      );
      return;
    }

    final bool isAvailable = res.message_code == 'EMAIL_AVAILABLE';

    if (isAvailable) {
      hasError.value = true;
      dismissLoading();
      loginError.value = AppErrors.getErrorLabel("EMAIL_UNAVAILABLE_LOGIN");
      return;
    }

    //> Login request
    try {
      final fcmToken = await _getFCMToken();

      final ResponseApi res = await _loginRepository.login(
        Login(
          email: emailController.text,
          password: passController.text,
          token_fcm: fcmToken,
        ),
      );

      if (res.status == 'error') {
        hasError.value = true;
        dismissLoading();

        final String messageCode = res.message_code ?? '';
        final dynamic remaining = (res.data is Map)
            ? (res.data as Map)['remaining_attempts']
            : null;

        if (messageCode == 'LOGIN_ACCOUNT_LOCKED') {
          isAccountLocked.value = true;
          loginError.value = 'login.error.account_locked_description'.tr;
        } else if (messageCode == 'LOGIN_WRONG_CREDENTIALS') {
          if (remaining != null && remaining == 0) {
            isAccountLocked.value = true;
            loginError.value = 'login.error.wrong_credentials_last_attempt'.tr;
          } else if (remaining != null) {
            loginError.value =
                'login.error.wrong_credentials_attempts'.trParams(
              {'remaining': remaining.toString()},
            );
          } else {
            loginError.value = 'login.error.wrong_credentials_generic'.tr;
          }
        } else {
          loginError.value = res.message;
        }

        logger.crashlyticsReport(
          tag: 'loginPassFailure',
          reportMessage: res.message,
          customData: {
            'api_response': res.toString(),
            'api_message_code': res.message_code,
            'http_status_code': res.code,
          },
        );

        return;
      }

      _toHome();
    } catch (e, s) {
      hasError.value = true;
      dismissLoading();
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'loginPassReq',
        reason: 'Falló el intento de inicio de sesión del usuario.',
        customData: {'email_attempt': emailController.text},
      );
    }
  }

  Future<String> _getFCMToken() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      return fcmToken ?? '';
    } catch (e) {
      logger.crashlyticsReport(
        tag: 'getFCMTokenFailure',
        reportMessage: e.toString(),
      );
      hasError.value = true;
      return '';
    }
  }

  void _toHome() async {
    try {
      Get.find<HomeController>().chargeData();

      Get.offAllNamed(AppRoutes.HOME);
    } catch (e, s) {
      hasError.value = true;

      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'navigateHome',
      );
    } finally {
      dismissLoading(context: Get.context!);
    }
  }
}
