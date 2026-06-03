import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/core/services/notification/controller/notification_controller.dart';
import 'package:wiigold/app/core/services/persistence/controllers/app_lifecycle_controller.dart';
import 'package:wiigold/app/data/services/biometric_service.dart';
import 'package:wiigold/app/data/services/navigation_persistence_service.dart';
import 'package:wiigold/app/data/storage/token_storage.dart';
import 'package:wiigold/app/routers/app_pages.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:wiigold/app/routers/app_routes.dart';

import 'package:wiigold/app/common/utils/logger.dart';

final Logger _backgroundLogger = Logger(module: 'FirebaseBackground');

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _backgroundLogger.log(
    label: '_firebaseMessagingBackgroundHandler',
    content: 'Mensaje recibido en segundo plano: ${message.messageId}',
    customData: message.data,
  );
}

class SplashController extends GetxController with LoadingMixin {
  final Logger _logger = Logger(module: 'SplashController');

  @override
  void onReady() {
    super.onReady();
    _initializeAppAndNavigate();
  }

  Future<void> _initializeAppAndNavigate() async {
    try {
      _logger.log(
        label: 'INITIALIZATION_PHASE_1',
        content: 'Inicialización de Servicios Base',
      );
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      Get.lazyPut(() => BiometricService());

      await Firebase.initializeApp();

      if (kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          true,
        );
        _logger.log(
          label: 'FirebaseSetup',
          content: 'Crashlytics habilitado en modo debug.',
        );
      } else {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          true,
        );
      }
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      _logger.log(
        label: 'FirebaseSetup',
        content: 'Firebase Core y Crashlytics configurados.',
      );

      _logger.log(
        label: 'INITIALIZATION_PHASE_1.5',
        content: 'Inicializando Servicio de Notificaciones',
      );
      await _initializeNotificationService();
      _logger.log(
        label: 'INITIALIZATION_PHASE_1.5_DONE',
        content: 'Servicio de Notificaciones listo.',
      );

      _logger.log(
        label: 'INITIALIZATION_PHASE_2',
        content: 'Determinando ruta inicial',
      );
      final String initialRoute =
          await _setupPersistenceAndDetermineInitialRoute();
      _logger.log(
        label: 'INITIALIZATION_PHASE_2_DONE',
        content: 'Ruta determinada: $initialRoute',
      );

      _logger.log(
        label: 'INITIALIZATION_PHASE_3',
        content: 'Navegando a la pantalla principal...',
      );

      Get.offAllNamed(AppRoutes.LOGIN);
      // Get.offAllNamed(initialRoute);
    } catch (e, stackTrace) {
      _logger.crashlyticsError(
        error: e,
        stackTrace: stackTrace,
        tag: 'FATAL_INITIALIZATION_ERROR',
        reason:
            'Error fatal durante la inicialización de la aplicación en SplashController.',
        forceSendInDebug: true,
      );
    }
  }

  Future<void> _initializeNotificationService() async {
    final NotificationController notificationController = Get.put(
      NotificationController(),
      permanent: true,
    );
    await notificationController.initialize();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String> _setupPersistenceAndDetermineInitialRoute() async {
    await GetStorage.init();
    Get.put(TokenStorage());
    await Get.putAsync(() => NavigationPersistenceService().init());
    Get.put(AppLifecycleController());

    final tokenStorage = Get.find<TokenStorage>();
    final persistenceService = Get.find<NavigationPersistenceService>();
    String determinedInitialRoute;
    final String currentToken = tokenStorage.getCurrentToken();

    if (currentToken.isNotEmpty) {
      String? lastRouteWithParams = persistenceService.getLastRoute();
      String? baseLastRoute;
      if (lastRouteWithParams != null && lastRouteWithParams.isNotEmpty) {
        try {
          baseLastRoute = Uri.parse(lastRouteWithParams).path;
        } catch (e) {
          baseLastRoute = null;
        }
      }
      bool isValidSavedRoute =
          baseLastRoute != null &&
          baseLastRoute.isNotEmpty &&
          baseLastRoute != AppRoutes.LOGIN &&
          AppPages.routes.any((getPage) => getPage.name == baseLastRoute);
      if (isValidSavedRoute) {
        determinedInitialRoute = lastRouteWithParams!;
      } else {
        await persistenceService.saveLastRoute(null);
        determinedInitialRoute = AppRoutes.HOME;
      }
    } else {
      determinedInitialRoute = AppRoutes.LOGIN;
      await persistenceService.saveLastRoute(null);
    }
    return determinedInitialRoute;
  }
}
