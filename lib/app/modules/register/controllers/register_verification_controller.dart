import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/data/models/request/login_model.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/login/respositories/login_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';

class RegisterVerificationController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RegisterVerificationController");

  Timer? _loginTimer;
  bool _isLoggingIn = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  late Login loginRequest = Login();
  RxString email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _handleParams();
  }

  @override
  void onReady() {
    super.onReady();
    startLoginTry();
  }

  @override
  void onClose() {
    _loginTimer?.cancel();
    super.onClose();
  }

  void startLoginTry() {
    _loginTimer?.cancel();
    _loginTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      tryLogin();
    });
  }

  void _handleParams() {
    final params = Get.parameters;

    if (params['registerRequest'] != null) {
      loginRequest = Login.fromJson(jsonDecode(params['registerRequest']!));
      email.value = loginRequest.email ?? '';
    }
  }

  Future<String> _getFCMToken() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      return fcmToken ?? '';
    } catch (e) {
      await logger.crashlyticsReport(
        tag: 'loginPassFailure',
        reportMessage: e.toString(),
      );
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: "Error al obtener token fcm",
      );
      return '';
    }
  }

  void tryLogin() async {
    if (_isLoggingIn) return;

    _isLoggingIn = true;
    showLoading(context: Get.context!);

    try {
      final fcmToken = await _getFCMToken();
      final LoginRepository loginRepository = LoginRepository();
      final ResponseApi res = await loginRepository.login(
        loginRequest.copyWith(token_fcm: fcmToken),
      );

      if (res.status == 'error') {
        logger.log(
          label: "tryLoginFailure",
          content: "Login attempt failed with message: ${res.message}",
        );
        return;
      }

      _toHome();
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'tryLoginReq',
        reason: 'Falló el intento de inicio de sesión del usuario.',
        customData: {'email_attempt': loginRequest.email},
      );
    } finally {
      dismissLoading();
      _isLoggingIn = false;
    }
  }

  void _toHome() async {
    _loginTimer?.cancel();

    Get.find<HomeController>().chargeData();

    Get.offAllNamed(AppRoutes.HOME);
  }
}
