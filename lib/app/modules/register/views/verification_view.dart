import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/modules/register/controllers/register_verification_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class VerificationView extends GetView<RegisterVerificationController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterVerificationController());
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.toLogin,
      appBar: DynamicAppBar(showLogo: true, showAutoBackButton: false),
      isContentCentered: true,
      onReady: controller.startLoginTry,
      body: VerificationPage(),
    );
  }
}

class VerificationPage extends GetView<RegisterVerificationController> {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: textTheme.displayMedium?.copyWith(
                height: 1.2,
                color: AppColors.dark,
              ),
              children: [
                TextSpan(text: 'register.verification_view.sent_link_message'.tr),
                TextSpan(
                  text: controller.email.value,
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.main,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        DynamicDivider(height: 20),

        Text(
          'register.verification_view.check_inbox_message'.tr,
          style: textTheme.titleSmall?.copyWith(
            overflow: TextOverflow.visible,
            color: AppColors.dark,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
