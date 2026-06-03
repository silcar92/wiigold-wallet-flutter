import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? SERVICES
import 'package:wiigold/app/data/services/navigation_persistence_service.dart';
import 'package:wiigold/app/data/storage/token_storage.dart';

class AppLifecycleController extends GetxController
    with WidgetsBindingObserver {
  final NavigationPersistenceService _persistenceService = Get.find();
  final TokenStorage _tokenStorage = Get.find();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _saveCurrentRouteIfLoggedIn();
        break;
      default:
        break;
    }
  }

  void _saveCurrentRouteIfLoggedIn() {
    final currentToken = _tokenStorage.getCurrentToken();
    final currentRoute = Get.currentRoute;

    if (currentToken.isNotEmpty) {
      if (currentRoute.isNotEmpty && currentRoute != AppRoutes.LOGIN) {
        _persistenceService.saveLastRoute(currentRoute);
      } else if (currentRoute == AppRoutes.LOGIN) {
        _persistenceService.saveLastRoute(null);
      } else {}
    } else {
      _persistenceService.saveLastRoute(null);
    }
  }
}
