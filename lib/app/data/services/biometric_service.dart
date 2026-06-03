import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wiigold/app/common/utils/logger.dart';

class BiometricService extends GetxService {
  final LocalAuthentication _auth = LocalAuthentication();

  final Logger _logger = Logger(module: "BiometricService");

  Future<bool> get isAuthenticationAvailable async {
    try {
      final bool canAuthenticate =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (e) {
      _logger.crashlyticsError(
        error: e,
        stackTrace: StackTrace.current,
        tag: 'checkAvailabilityFail',
        reason:
            'Error de plataforma al comprobar la disponibilidad de autenticación local.',
      );
      return false;
    }
  }

  Future<bool> authenticate({required String reason}) async {
    if (!await isAuthenticationAvailable) {
      _logger.log(
        enable: false,
        label: 'authenticate',
        content:
            'Se intentó autenticar en un dispositivo no compatible o sin métodos de autenticación configurados.',
      );
      return false;
    }

    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate) {
        _logger.log(
          enable: false,
          label: 'authenticate',
          content: 'Autenticación exitosa.',
          customData: {'reason': reason},
        );
      } else {
        _logger.log(
          enable: false,
          label: 'authenticate',
          content: 'Autenticación cancelada por el usuario.',
          customData: {'reason': reason},
        );
      }

      return didAuthenticate;
    } on PlatformException catch (e, s) {
      _logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'authenticateFail',
        reason: 'Falló la autenticación debido a una excepción de plataforma.',
        customData: {'platform_error_code': e.code, 'reason_prompt': reason},
      );
      return false;
    }
  }
}
