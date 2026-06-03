import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/core/services/notification/repositories/notification_repository.dart';
import 'package:wiigold/app/data/models/entities/notification_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/config/environment.dart';
import 'package:wiigold/main.dart';

class GroupedNotifications {
  final DateTime date;
  final List<NotificationModel> notifications;

  GroupedNotifications({required this.date, required this.notifications});
}

class NotificationController extends GetxController with LoadingMixin {
  final Logger _logger = Logger(module: 'NotificationController');

  late final TextTheme textTheme;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage _storage = GetStorage();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  StreamSubscription<RemoteMessage>? _onMessageSubscription;

  final RxList<NotificationModel> _rawNotificationList =
      <NotificationModel>[].obs;
  final RxList<GroupedNotifications> groupedNotifications =
      <GroupedNotifications>[].obs;

  NotificationController() {
    textTheme = Theme.of(Get.context!).textTheme;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initialize() async {
    await _initializeFirebaseMessaging();
    await refreshListeners();
    _setupInteractionListeners();
  }

  Future<void> _initializeFirebaseMessaging() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        _logger.log(
          label: 'APNS_TOKEN_CHECK',
          content: apnsToken ?? 'NULL - Configuración Incorrecta',
        );
      }
    } else {
      await _firebaseMessaging.requestPermission();
    }

    String? fcmToken;

    try {
      fcmToken = await _firebaseMessaging.getToken();
    } catch (e, stackTrace) {
      if (Platform.isIOS && kDebugMode) {
        _logger.crashlyticsReport(
          tag: 'APNS_TOKEN_SIMULATOR',
          reportMessage:
              'No se pudo obtener el token APNS. Comportamiento esperado en simulador iOS.',
          customData: {'error': e.toString()},
        );
      } else {
        _logger.crashlyticsError(
          error: e,
          stackTrace: stackTrace,
          tag: 'GET_FCM_TOKEN_FAIL',
          reason:
              'Fallo al obtener el token FCM en un dispositivo real o Android.',
        );
      }
    }

    if (fcmToken != null) {
      _logger.log(label: 'FCM_TOKEN_OBTAINED', content: fcmToken);
    } else {
      _logger.log(
        label: 'FCM_TOKEN_STATUS',
        content:
            'No se pudo obtener el token FCM (ver reporte si estás en simulador iOS).',
      );
    }
  }

  void _setupInteractionListeners() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.log(
        label: 'onMessageOpenedApp',
        content:
            'Usuario abrió la app desde segundo plano a través de una notificación.',
        customData: message.data,
      );
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _logger.log(
          label: 'getInitialMessage',
          content:
              'App abierta desde estado terminado a través de una notificación.',
          customData: message.data,
        );
      }
    });
  }

  Future<void> refreshListeners() async {
    await _onMessageSubscription?.cancel();
    bool userPrefersNotifications =
        _storage.read<bool>(
          EnvironmentConfig.userPrefersNotificationsStorageKey,
        ) ??
        true;
    if (!userPrefersNotifications) return;

    NotificationSettings settings = await _firebaseMessaging
        .getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _onMessageSubscription = FirebaseMessaging.onMessage.listen((
        RemoteMessage message,
      ) async {
        if (!(_storage.read<bool>(
              EnvironmentConfig.userPrefersNotificationsStorageKey,
            ) ??
            true))
          return;

        _logger.log(
          label: 'ForegroundMessageReceived',
          content: 'Message ID: ${message.messageId}',
          customData: message.data,
        );

        await showLocalNotification(message);
      });
    }
  }

  @override
  void onClose() {
    _onMessageSubscription?.cancel();
    super.onClose();
  }

  Future<void> initialCharge() async {
    await chargeData();
  }

  Future<void> chargeData() async {
    showLoading();
    try {
      ResponseApi res = await _notificationRepository.getAllNotifications();
      if (res.status == 'error' ||
          res.data == null ||
          res.data is! List<dynamic>) {
        _rawNotificationList.clear();
        groupedNotifications.clear();
        return;
      }
      final List<dynamic> notificationsJsonList = res.data as List<dynamic>;
      List<NotificationModel> fetchedNotifications = notificationsJsonList
          .map(
            (jsonItem) => (jsonItem is Map<String, dynamic>)
                ? NotificationModel.fromJson(jsonItem)
                : null,
          )
          .whereType<NotificationModel>()
          .toList();
      _rawNotificationList.assignAll(fetchedNotifications);
      final Map<DateTime, List<NotificationModel>> groupedMap =
          _groupNotificationsByDate(fetchedNotifications);
      final List<GroupedNotifications> result = groupedMap.entries.map((entry) {
        return GroupedNotifications(
          date: entry.key,
          notifications: entry.value,
        );
      }).toList();
      groupedNotifications.assignAll(result);
    } catch (e, stackTrace) {
      _logger.crashlyticsError(
        error: e,
        stackTrace: stackTrace,
        tag: 'FETCH_NOTIFICATIONS_FAIL',
        reason: 'Error al obtener las notificaciones desde la API.',
      );
      _rawNotificationList.clear();
      groupedNotifications.clear();
    } finally {
      dismissLoading();
    }
  }

  Map<DateTime, List<NotificationModel>> _groupNotificationsByDate(
    List<NotificationModel> notifications,
  ) {
    final Map<DateTime, List<NotificationModel>> grouped =
        SplayTreeMap<DateTime, List<NotificationModel>>(
          (b, a) => a.compareTo(b),
        );
    for (final notification in notifications) {
      final dateTime = notification.createdAt;
      final dateKey = DateTime(dateTime.year, dateTime.month, dateTime.day);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }
    return grouped;
  }
}
