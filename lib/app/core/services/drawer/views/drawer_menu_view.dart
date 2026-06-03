import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/dynamic_logo.dart';
import 'package:wiigold/app/modules/auth/controllers/auth_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? CONTROLLERS
import 'package:wiigold/app/core/services/drawer/controllers/drawer_menu_controller.dart';

//? WIDGETS
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

enum DrawerItem {
  home,
  send,
  request,
  scanQR,
  loan,
  receiveMineral,
  profile,
  contact,
  logout,
}

class DrawerItemData {
  final DrawerItem item;
  final String label;
  final String? route;
  final IconData? icon;
  final Map<String, String>? parameters;

  DrawerItemData({
    required this.item,
    required this.label,
    this.route,
    this.icon,
    this.parameters,
  });
}

class DrawerView extends GetView<DrawerMenuController> {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  final List<DrawerItemData> drawerSource = [
    DrawerItemData(
      item: DrawerItem.home,
      label: 'drawer.view.home'.tr,
      route: AppRoutes.HOME,
    ),
    DrawerItemData(
      item: DrawerItem.send,
      label: 'drawer.view.send'.tr,
      route: AppRoutes.SEND_SELECTOR,
    ),
    DrawerItemData(
      item: DrawerItem.request,
      label: 'drawer.view.request'.tr,
      route: AppRoutes.REQUEST_SELECTOR,
    ),
    DrawerItemData(
      item: DrawerItem.scanQR,
      label: 'drawer.view.scan_qr'.tr,
      route: AppRoutes.QR,
      parameters: {"viewMode": "SCAM_QR"},
    ),
  /*
    DrawerItemData(
      item: DrawerItem.loan,
      label: 'drawer.view.request_loan'.tr,
      route: AppRoutes.LOAN,
    ),
    DrawerItemData(
      route: AppRoutes.REDEEM,
      item: DrawerItem.receiveMineral,
      label: 'drawer.view.receive_physical_mineral'.tr,
    ),
    */
    DrawerItemData(
      item: DrawerItem.profile,
      label: 'drawer.view.my_profile'.tr,
      route: AppRoutes.PROFILE,
    ),
    DrawerItemData(
      item: DrawerItem.contact,
      label: 'drawer.view.contact'.tr,
      route: AppRoutes.CLAIM,
    ),
    DrawerItemData(
      item: DrawerItem.logout,
      label: 'drawer.view.logout'.tr,
      icon: Icons.logout,
    ),
  ];

  DrawerView({super.key, this.scaffoldKey});

  void _handleItemTap(DrawerItemData item) {
    if (scaffoldKey != null) {
      controller.closeDrawer(scaffoldKey!);
    }

    switch (item.item) {
      case DrawerItem.logout:
        Get.put(AuthController()).logout();
        break;

      default:
        if (item.route != null) {
          Get.toNamed(item.route!, parameters: item.parameters);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Drawer(
      width: double.infinity,
      backgroundColor: AppColors.light2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 20),
                  child: DynamicLogo(),
                ),
                IconButton(
                  color: AppColors.main,
                  onPressed: () {
                    if (scaffoldKey != null) {
                      controller.closeDrawer(scaffoldKey!);
                    }
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          DynamicDivider(height: 100),

          Column(
            children: [
              ...drawerSource.map((item) {
                final bool isLogout = item.item == DrawerItem.logout;
                return ListTile(
                  dense: true,
                  title: Text(
                    item.label,
                    style:
                        (isLogout
                                ? textTheme.titleMedium
                                : textTheme.titleLarge)
                            ?.copyWith(
                              color: AppColors.main,
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  trailing: item.icon != null
                      ? Icon(item.icon, color: AppColors.main)
                      : null,
                  onTap: () => _handleItemTap(item),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
