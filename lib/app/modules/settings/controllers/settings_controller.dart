import 'package:flutter/material.dart';

//? getX
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//? FIREBASE
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/notification/controller/notification_controller.dart';
import 'package:wiigold/app/core/services/notification/repositories/notification_repository.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/config/environment.dart';
import 'package:wiigold/theme/Colors.dart';

//? HANDLERS
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class SettingsController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage _storage = GetStorage();

  final RxBool uiShowNotificationsToggle = true.obs;

  final Rx<AuthorizationStatus> _osPermissionStatus =
      AuthorizationStatus.notDetermined.obs;

  @override
  void onInit() async {
    super.onInit();

    await _initializeNotificationSettings();
  }

  Future<void> _initializeNotificationSettings() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    _osPermissionStatus.value = settings.authorizationStatus;

    bool userPrefersNotifications =
        _storage.read<bool>(
          EnvironmentConfig.userPrefersNotificationsStorageKey,
        ) ??
        true;

    bool actualToggleState;

    if (userPrefersNotifications) {
      if (_osPermissionStatus.value == AuthorizationStatus.authorized ||
          _osPermissionStatus.value == AuthorizationStatus.provisional) {
        actualToggleState = true;
      } else if (_osPermissionStatus.value ==
          AuthorizationStatus.notDetermined) {
        actualToggleState = true;
      } else {
        actualToggleState = false;

        if (userPrefersNotifications) {
          await _storage.write(
            EnvironmentConfig.userPrefersNotificationsStorageKey,
            false,
          );
        }
      }
    } else {
      actualToggleState = false;
    }

    uiShowNotificationsToggle.value = actualToggleState;

    if (uiShowNotificationsToggle.value &&
        _osPermissionStatus.value == AuthorizationStatus.authorized) {
      await _enableFcmClientFeatures();
    } else {
      await _disableFcmClientFeatures();
    }
  }

  Future<void> _enableFcmClientFeatures() async {
    await _firebaseMessaging.setAutoInitEnabled(true);
  }

  Future<void> _disableFcmClientFeatures() async {
    await _firebaseMessaging.setAutoInitEnabled(false);
  }

  Future<void> _checkAndUpdateOsPermissionStatus() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    _osPermissionStatus.value = settings.authorizationStatus;
  }

  Future<void> toggleShowNotifications(bool desiredState) async {
    try {
      if (desiredState) {
        await _checkAndUpdateOsPermissionStatus();

        if (_osPermissionStatus.value == AuthorizationStatus.authorized) {
          await _storage.write(
            EnvironmentConfig.userPrefersNotificationsStorageKey,
            true,
          );

          uiShowNotificationsToggle.value = true;

          await _enableFcmClientFeatures();

          String? token = await _firebaseMessaging.getToken();

          if (token != null) {
            final NotificationRepository notificationRepository =
                NotificationRepository();

            ResponseApi resUpdateFCM = await notificationRepository.updateFCM({
              "fcm_token": token,
            });

            if (resUpdateFCM.message_code != 'TOKEN_FCM_UPDATED') {
              DynamicToast.error(
                title: "Error",
                description: AppErrors.getErrorLabel(resUpdateFCM.message),
              );
            }
          }
        } else if (_osPermissionStatus.value == AuthorizationStatus.denied) {
          uiShowNotificationsToggle.value = false;
          await _storage.write(
            EnvironmentConfig.userPrefersNotificationsStorageKey,
            false,
          );
          _showOpenSettingsSnackbar();
        } else {
          NotificationSettings settings = await _firebaseMessaging
              .requestPermission(
                alert: true,
                badge: true,
                sound: true,
                provisional: false,
              );

          _osPermissionStatus.value = settings.authorizationStatus;

          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            await _storage.write(
              EnvironmentConfig.userPrefersNotificationsStorageKey,
              true,
            );

            uiShowNotificationsToggle.value = true;

            await _enableFcmClientFeatures();
          } else {
            await _storage.write(
              EnvironmentConfig.userPrefersNotificationsStorageKey,
              false,
            );

            uiShowNotificationsToggle.value = false;

            await _disableFcmClientFeatures();

            if (GetPlatform.isIOS &&
                settings.authorizationStatus == AuthorizationStatus.denied) {
              _showOpenSettingsSnackbar();
            }
          }
        }
      } else {
        await _storage.write(
          EnvironmentConfig.userPrefersNotificationsStorageKey,
          false,
        );
        uiShowNotificationsToggle.value = false;
        await _disableFcmClientFeatures();
        try {
          await _firebaseMessaging.deleteToken();
        } catch (e) {}
      }

      await Get.find<NotificationController>().refreshListeners();
    } catch (e) {
      DynamicToast.error(
        title:
            'Ocurrió un error al cambiar la configuración de notificaciones.',
      );

      await _initializeNotificationSettings();
    }
  }

  void _showOpenSettingsSnackbar() {
    DynamicToast.error(
      title: 'Permiso Requerido',
      description:
          "Para recibir notificaciones, habilita los permisos en la configuración de la aplicación.",
      mainButton: GetPlatform.isIOS || GetPlatform.isAndroid
          ? TextButton(
              onPressed: () {
                permission_handler.openAppSettings();
              },
              child: Text(
                "Abrir ajustes",
                style: TextStyle(color: AppColors.main),
              ),
            )
          : null,
    );
  }
}
