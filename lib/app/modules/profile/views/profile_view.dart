import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? THEMES & IMAGES
import 'package:flutter_svg/svg.dart';

//? WIDGETS
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/auth/controllers/auth_controller.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/theme/Responsive.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.find<ProfileController>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(scaffoldKey: scaffoldKey, showActions: true),

      body: ProfilePage(),
      bottomNavigationBar: DynamicBottomNavigation(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfileTitle(),
        DynamicDivider(height: 50),
        OptionsLinks(),
        DynamicDivider(height: 50),
        LogoutButton(),
      ],
    );
  }
}

class ProfileTitle extends StatelessWidget {
  ProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "profile.view.title".tr,
          style: textTheme.displayLarge?.copyWith(color: AppColors.main),
        ),
      ],
    );
  }
}

class OptionsLinks extends GetView<ProfileController> {
  const OptionsLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    return Column(
      spacing: 15,
      children: [
        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'data_profile_otpLink'),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          height: 45,
          borderColor: AppColors.main,
          baseColor: AppColors.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'profile.view.my_data_button'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.main),
              ),
              Icon(
                Icons.double_arrow,
                size: 30 * scaleFactor,
                color: AppColors.main,
              ),
            ],
          ),
          onPressed: () async {
            Get.toNamed(AppRoutes.PROFILE_DATA);
          },
        ),
        DynamicButton(
          semanticSettings: ButtonSemantics(
            identifier: 'data_profile_kycState',
          ),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          height: 45,
          borderColor: AppColors.main,
          baseColor: AppColors.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'profile.view.kyc_status_button'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.main),
              ),
              Icon(
                Icons.double_arrow,
                size: 30 * scaleFactor,
                color: AppColors.main,
              ),
            ],
          ),
          onPressed: () {
            Get.toNamed(AppRoutes.PROFILE_KYC);
          },
        ),
        /*
        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'data_profile_privacy'),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          height: 45,
          borderColor: AppColors.main,
          baseColor: AppColors.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'profile.view.privacy_policy_button'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.main),
              ),
              Icon(
                Icons.double_arrow,
                size: 30 * scaleFactor,
                color: AppColors.main,
              ),
            ],
          ),
          onPressed: () {},
        ),
        */
        DynamicButton(
          semanticSettings: ButtonSemantics(
            identifier: 'data_profile_conditions',
          ),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          height: 45,
          borderColor: AppColors.main,
          baseColor: AppColors.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'profile.view.terms_and_conditions_button'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.main),
              ),
              Icon(
                Icons.double_arrow,
                size: 30 * scaleFactor,
                color: AppColors.main,
              ),
            ],
          ),
          onPressed: () => controller.viewTermAndCondictions(),
        ),
        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'data_profile_about'),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          height: 45,
          borderColor: AppColors.main,
          baseColor: AppColors.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'profile.view.about_button'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.main),
              ),
              Icon(
                Icons.double_arrow,
                size: 30 * scaleFactor,
                color: AppColors.main,
              ),
            ],
          ),
          onPressed: () {},
        ),
        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'data_profile_2fa'),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          height: 45,
          borderColor: AppColors.main,
          baseColor: AppColors.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'profile.view.security_button'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.main),
              ),
              Icon(
                Icons.double_arrow,
                size: 30 * scaleFactor,
                color: AppColors.main,
              ),
            ],
          ),
          onPressed: () {
            Get.toNamed(AppRoutes.SECURITY_2FA);
          },
        ),
        DynamicButton(
          semanticSettings: ButtonSemantics(
            identifier: 'data_profile_settings',
          ),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          height: 45,
          borderColor: AppColors.main,
          baseColor: AppColors.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'profile.view.settings_button'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.main),
              ),
              Icon(
                Icons.double_arrow,
                size: 30 * scaleFactor,
                color: AppColors.main,
              ),
            ],
          ),
          onPressed: () {
            Get.toNamed(AppRoutes.SETTINGS);
          },
        ),
      ],
    );
  }
}

class LogoutButton extends GetView<AuthController> {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: GestureDetector(
            onTap: controller.logout,
            child: Row(
              spacing: 10,
              children: [
                Text(
                  'profile.view.logout_button'.tr,
                  style: textTheme.titleMedium?.copyWith(color: AppColors.main),
                ),
                Icon(Icons.logout, color: AppColors.main),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
