import 'package:flutter/material.dart';

//? GetX IMPORTS
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/dynamic_logo.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? THEME & LOGIN
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS
import 'package:wiigold/app/core/services/drawer/controllers/drawer_menu_controller.dart'
    as DrawerController;

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogo;
  final bool showActions;
  final bool showAutoBackButton;
  final Widget? leading;

  final Widget? title;
  final Color? color;

  final Function()? backbuttomFunction;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  const DynamicAppBar({
    super.key,
    this.scaffoldKey,
    this.showLogo = true,
    this.showActions = false,
    this.showAutoBackButton = true,
    this.backbuttomFunction,
    this.color = AppColors.appAltBackground,
    this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> contents = [];

    if (showLogo) {
      contents.add(DynamicLogo());
    }

    if (title != null) {
      contents.add(title!);
    }

    return AppBar(
      backgroundColor: color,
      elevation: 0,
      automaticallyImplyLeading: showAutoBackButton,
      leading: showAutoBackButton
          ? leading ??
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.main),
                  onPressed: backbuttomFunction ?? () => Get.back(),
                )
          : null,
      iconTheme: IconThemeData(color: AppColors.main),
      title: Row(
        mainAxisAlignment: title != null
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: contents,
      ),
      actions: showActions
          ? [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Get.toNamed(AppRoutes.NOTIFICATIONS);
                },
              ),
              IconButton(
                icon: Icon(Icons.menu_sharp),
                onPressed: () {
                  if (scaffoldKey != null) {
                    Get.put(
                      DrawerController.DrawerMenuController(),
                    ).openDrawer(scaffoldKey!);
                  }
                },
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
