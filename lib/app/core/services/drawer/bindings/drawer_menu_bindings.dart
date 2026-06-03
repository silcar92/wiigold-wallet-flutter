import 'package:get/get.dart';

//? CONTROLLERS
import 'package:wiigold/app/core/services/drawer/controllers/drawer_menu_controller.dart';

class DrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrawerMenuController>(() => DrawerMenuController());
  }
}
