import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DrawerMenuController extends GetxController {
  late TextTheme textTheme;

  @override
  void onReady() {
    super.onReady();
    textTheme = Theme.of(Get.context!).textTheme;
  }

  openDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  closeDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openEndDrawer();
    }
  }
}
