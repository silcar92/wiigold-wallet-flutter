import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? HANDLERS

//? COLORS & IMAGES

//? WIDGETS

//? OTHERS
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_qrscanner.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_qr.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/qr/controllers/qr_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class QrView extends GetView<QrController> {
  const QrView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(
        title: Text('qr.view.appbar_title'.tr),
        showLogo: false,
        showActions: false,
        backbuttomFunction: () async {
          Get.back();
        },
      ),
      onCustomBack: () {
        Get.back();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      isContentCentered: true,
      body: QrPage(),
      bottomNavigationBar: DynamicBottomNavigation(),
    );
  }
}

class QrPage extends GetView<QrController> {
  const QrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget showQR() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: textTheme.displayMedium?.copyWith(fontSize: 40, height: 1),
              children: [
                TextSpan(text: 'qr.view.scan_qr_title_part1'.tr),
                TextSpan(
                  text: 'qr.view.scan_qr_title_part2'.tr,
                  style: TextStyle(color: AppColors.main),
                ),
              ],
            ),
          ),

          DynamicDivider(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [DynamicQr(data: controller.accountAddress)],
          ),

          DynamicDivider(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicButton(
                baseColor: Colors.transparent,
                borderColor: AppColors.main,
                isGradient: false,
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                onPressed: () => controller.toggleMode(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.qr_code, size: 20, color: AppColors.main),
                    SizedBox(width: 8),
                    Text(
                      'qr.view.change_mode_button'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget scanQR() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicQRScanner(
                width: 300,
                height: 300,
                onDetect: controller.onDetect,
              ),
            ],
          ),

          DynamicDivider(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicButton(
                baseColor: Colors.transparent,
                borderColor: AppColors.main,
                isGradient: false,
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                onPressed: () => controller.toggleMode(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.qr_code, size: 20, color: AppColors.main),
                    SizedBox(width: 8),
                    Text(
                      'qr.view.change_mode_button_2'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Obx(
      () => controller.viewMode.value == 'SHOW_QR'
          ? !controller.showQr.value
                ? Container()
                : showQR()
          : scanQR(),
    );
  }
}
