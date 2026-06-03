import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? Controller

//? THEME & IMAGES

//? WIDGETS

//? QRScanner

class RedeemFinishView extends StatelessWidget {
  const RedeemFinishView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final RxBool isLoading = false.obs;

    return DynamicAppScaffold(
      isLoading: isLoading,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        Get.toNamed(AppRoutes.REDEEM);
      },
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: true,
        showAutoBackButton: false,
        showActions: true,
        backbuttomFunction: () {
          Get.toNamed(AppRoutes.REDEEM);
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      body: RedeemFinishPage(),
      bottomNavigationBar: DynamicBottomNavigation(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class RedeemFinishPage extends StatelessWidget {
  const RedeemFinishPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: 10,
      children: [
        DynamicDivider(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: textTheme.displayLarge?.copyWith(height: 1),
                  children: [
                    TextSpan(
                      text: 'redeem.finish_view.title_part1_highlight'.tr,
                      style: textTheme.displayLarge?.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                    TextSpan(text: 'redeem.finish_view.title_part2'.tr),
                  ],
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                'redeem.finish_view.subtitle'.tr,
                style: textTheme.titleSmall?.copyWith(
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),

        DynamicDivider(height: 30),

        DynamicButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.REDEEM);
          },
          isGradient: true,
          baseColor: AppColors.main,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'redeem.finish_view.back_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
