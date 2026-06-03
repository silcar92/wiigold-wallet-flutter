import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? THEMES & IMAGES

//? WIDGETS

//? QR
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_qr.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/request/controllers/request_controller.dart';
import 'package:wiigold/app/modules/request/widgets/request_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class RequestShareView extends GetView<RequestController> {
  const RequestShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(showLogo: false, title: RequestAppbarTitle()),
      isContentCentered: true,
      body: RequestSharePage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.request,
      ),
    );
  }
}

class RequestSharePage extends GetView<RequestController> {
  const RequestSharePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final fontSize = controller.getAmountFontSize(
      controller.amountController.text.toHauvNumericString(),
    );

    List<Widget> shareMethods() {
      return [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.displayMedium?.copyWith(
                  height: 0.9,
                  fontSize: 30,
                ),
                children: [
                  TextSpan(text: 'request.share_view.title_part1'.tr),

                  TextSpan(
                    text: 'request.share_view.title_part2'.tr,
                    style: TextStyle(color: AppColors.main),
                  ),
                  TextSpan(text: 'request.share_view.title_part3'.tr),
                ],
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.end,
                softWrap: true,
                text: TextSpan(
                  style: textTheme.displaySmall?.copyWith(
                    height: 1,
                    color: AppColors.main,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${controller.amountController.text.toHauvNumericString()}\n',
                      style: TextStyle(
                        color: AppColors.main,
                        fontSize: fontSize,
                      ),
                    ),
                    TextSpan(
                      text:
                          controller.selectedToken.value?.asset_info?.name ??
                          '',
                      style: TextStyle(color: AppColors.main),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        DynamicDivider(height: 75),

        DynamicButton(
          semanticSettings: ButtonSemantics(
            identifier: 'send_insert_address_continue_button',
          ),
          disabledColor: AppColors.dark2,
          isGradient: true,
          onPressed: controller.generateQrCode,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.qr_code, size: 20, color: AppColors.light),
              SizedBox(width: 8),
              Text(
                'request.share_view.generate_qr_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 15),

        DynamicButton(
          semanticSettings: const ButtonSemantics(
            identifier: 'send_insert_amount_continue_button',
          ),

          baseColor: AppColors.transparent,
          borderColor: AppColors.main,

          onPressed: controller.copyPaymentLink,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.copy, size: 20, color: AppColors.main),
              SizedBox(width: 8),
              Text(
                'request.share_view.copy_link_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 15),

        DynamicButton(
          semanticSettings: ButtonSemantics(
            identifier: 'send_insert_amount_continue_button',
          ),
          baseColor: AppColors.transparent,
          borderColor: AppColors.main,
          onPressed: () => controller.sharePaymentLink(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.share, size: 20, color: AppColors.main),
              SizedBox(width: 8),
              Text(
                'request.share_view.share_link_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 15),

        DynamicButton(
          baseColor: AppColors.transparent,
          borderColor: AppColors.main,

          onPressed: () async {
            Get.find<HomeController>().chargeData();

            Get.offAllNamed(AppRoutes.HOME);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 8),
              Text(
                'request.share_view.back_to_home_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ];
    }

    List<Widget> qrView() {
      return [
        DynamicDivider(height: 30),

        RichText(
          text: TextSpan(
            style: textTheme.displayMedium?.copyWith(height: 1.1, fontSize: 48),
            children: [TextSpan(text: 'request.share_view.qr_title'.tr)],
          ),
        ),

        DynamicDivider(height: 30),

        DynamicQr(data: controller.requestLink.value),

        /*

        QrImageView(
          data: controller.requestLink.value,
          version: QrVersions.auto,
          size: 225.0,
          backgroundColor: AppColors.main,
          dataModuleStyle: QrDataModuleStyle(
            color: AppColors.light,
            dataModuleShape: QrDataModuleShape.square,
          ),
          eyeStyle: QrEyeStyle(
            color: AppColors.light,
            eyeShape: QrEyeShape.square,
          ),
          padding: EdgeInsets.all(10),
        ),
         */
        DynamicDivider(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.displayMedium?.copyWith(
                  height: 1,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: 'request.share_view.qr_instruction_part1'.tr),

                  TextSpan(text: 'request.share_view.qr_instruction_part2'.tr),

                  TextSpan(text: 'request.share_view.qr_instruction_part3'.tr),
                ],
              ),
            ),

            Obx(() {
              final amountText = controller.amount.value;
              final fontSize = controller.getAmountFontSize(amountText);

              return RichText(
                text: TextSpan(
                  style: textTheme.displayMedium?.copyWith(
                    height: 1,
                    fontSize: fontSize,
                  ),
                  children: [
                    TextSpan(
                      text: '$amountText \n',
                      style: TextStyle(color: AppColors.main),
                    ),
                    TextSpan(
                      text:
                          controller.selectedToken.value?.asset_info?.name ??
                          '',
                      style: TextStyle(color: AppColors.main, fontSize: 18),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),

        DynamicDivider(height: 50),

        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'hide_qr_button'),

          baseColor: AppColors.transparent,
          borderColor: AppColors.main,

          onPressed: controller.hideQrCode,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(Icons.arrow_back, size: 20, color: AppColors.main),
              SizedBox(width: 8),
              Text(
                'request.share_view.return_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 15),

        DynamicButton(
          onPressed: () async {
            Get.find<HomeController>().chargeData();

            Get.offAllNamed(AppRoutes.HOME);
          },
          disabledColor: AppColors.dark2,
          baseColor: AppColors.main,
          isGradient: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'request.share_view.back_to_home_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
            ],
          ),
        ),
      ];
    }

    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isQrVisible.value) ...qrView() else ...shareMethods(),
        ],
      ),
    );
  }
}
