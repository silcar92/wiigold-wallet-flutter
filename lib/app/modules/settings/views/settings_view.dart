import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_toggle.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/settings/controllers/settings_controller.dart';
import 'package:wiigold/app/modules/settings/widgets/language_selector.dart';

//? CONTROLLERS

//? THEME & IMAGES

//? WIDGETS

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final RxBool isLoading = false.obs;

    return DynamicAppScaffold(
      isLoading: isLoading,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.standard,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showAutoBackButton: true,
        showActions: true,
        backbuttomFunction: () {
          Get.back();
        },
      ),
      isContentCentered: false,
      body: SettingsPage(),
      bottomNavigationBar: DynamicBottomNavigation(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'settings.settings_view.title'.tr,
            style: textTheme.displayMedium,
          ),
          const SizedBox(height: 20),
          SettingsFormCore(),
        ],
      ),
    );
  }
}

class SettingsFormCore extends GetView<SettingsController> {
  const SettingsFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LanguageSelector(),
        DynamicDivider(height: 20),
        Obx(() {
          return DynamicToggle(
            label: 'settings.settings_view.notifications_toggle_label'.tr,
            value: controller.uiShowNotificationsToggle.value,
            onChanged: (bool newValue) {
              controller.toggleShowNotifications(newValue);
            },
          );
        }),
      ],
    );
  }
}
