import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPersistenceService extends GetxService {
  static const _lastRouteKey = 'last_route_v3';
  late SharedPreferences _prefs;

  Future<NavigationPersistenceService> init() async {
    _prefs = await SharedPreferences.getInstance();

    return this;
  }

  Future<void> saveLastRoute(String? routeName) async {
    if (routeName != null && routeName.isNotEmpty) {
      await _prefs.setString(_lastRouteKey, routeName);
    } else {
      await _prefs.remove(_lastRouteKey);
    }
  }

  String? getLastRoute() {
    final route = _prefs.getString(_lastRouteKey);

    return route;
  }
}
