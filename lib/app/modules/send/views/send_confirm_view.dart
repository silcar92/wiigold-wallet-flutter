import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? THEMES & IMAGES

//? WIDGETS
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/send/controllers/send_controller.dart';
import 'package:wiigold/app/modules/send/widgets/send_appbar_title.dart';
import 'package:wiigold/theme/Colors.dart';

class SendConfirmView extends StatelessWidget {
  const SendConfirmView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.find<SendController>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(showLogo: false, title: SendAppbarTitle()),
      contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 50),
      body: SendConfirmPage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.send,
      ),
    );
  }
}

class SendConfirmPage extends GetView<SendController> {
  const SendConfirmPage({super.key});

  @override
  //? ROOT PAGE
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final fontSize = controller.getAmountFontSize(
      controller.amountController.text.toHauvNumericString(),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.displayMedium?.copyWith(
                  height: 0.9,
                  fontSize: 40,
                ),
                children: [TextSpan(text: 'send.confirm_view.title'.tr)],
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
                      style: TextStyle(fontSize: fontSize),
                    ),
                    TextSpan(
                      text:
                          controller.selectedToken.value?.asset_info?.name ??
                          '',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        DynamicDivider(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: RichText(
                text: TextSpan(
                  style: textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: 'send.confirm_view.to_wallet'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: "${controller.targetName.value}\n",
                      style: textTheme.bodyLarge?.copyWith(
                        height: 1.1,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: "${controller.targetAddress.value}\n",
                      style: TextStyle(
                        height: 1.1,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        DynamicDivider(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                style: textTheme.displayMedium?.copyWith(
                  height: 1.3,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'send.confirm_view.transaction_fee'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text:
                        '-${controller.commission.value} ${controller.selectedToken.value?.asset_info?.name ?? ''}',
                    style: TextStyle(fontSize: 20, color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ],
        ),
        DynamicDivider(height: 50),
        ConfirmCore(),
      ],
    );
  }
}

class ConfirmCore extends GetView<SendController> {
  const ConfirmCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        DynamicButton(
          semanticSettings: ButtonSemantics(
            identifier: 'send_insert_amount_continue_button',
          ),
          baseColor: AppColors.main,
          isGradient: true,
          onPressed: controller.submitConfirmForm,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'send.confirm_view.continue_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
              Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
            ],
          ),
        ),
        DynamicDivider(height: 10),
        DynamicButton(
          semanticSettings: ButtonSemantics(
            identifier: 'send_insert_amount_continue_button',
          ),
          baseColor: Colors.transparent,
          borderColor: AppColors.main,
          onPressed: () => {Get.back()},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Icon(Icons.arrow_back, size: 20, color: AppColors.main),
              Text(
                'send.confirm_view.modify_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
