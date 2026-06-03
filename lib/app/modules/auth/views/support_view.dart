import 'package:flutter/material.dart';

// GetX
import 'package:get/get.dart';

//? CONTROLLER

//? THEMES & IMAGES

//? WIDGETS
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/auth/controllers/auth_controller.dart';
import 'package:wiigold/app/modules/auth/widgets/auth_appbar_title.dart';
import 'package:wiigold/theme/Colors.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final RxBool isLoading = false.obs;

    return DynamicAppScaffold(
      isLoading: isLoading,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(showLogo: false, title: AuthAppbarTitle()),
      body: SupportPage(),
    );
  }
}

class SupportPage extends GetView<AuthController> {
  const SupportPage({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      color: AppColors.dark,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.displayLarge?.copyWith(height: 0.9),
                children: [
                  TextSpan(text: 'auth.support_view.title_part1'.tr),
                  TextSpan(
                    text: 'auth.support_view.title_part2'.tr,
                    style: TextStyle(color: AppColors.main),
                  ),
                ],
              ),
            ),
            DynamicDivider(height: 20),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      controller.verificationError.value != ''
                          ? controller.verificationError.value
                          : "auth.support_view.subtitle".tr,
                      style: textTheme.titleMedium?.copyWith(
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /*
            if (controller.verificationError.value != '') ...[
              DynamicDivider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      controller.verificationError.value,
                      style: textTheme.titleMedium?.copyWith(
                        overflow: TextOverflow.visible,
                        color: AppColors.colorFailure,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            */
            DynamicDivider(height: 50),
            DynamicButton(
              onPressed: controller.contactSupport,
              isGradient: true,
              baseColor: AppColors.main,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 8,
                children: [
                  Text(
                    'auth.support_view.contact_button'.tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),
            DynamicDivider(height: 20),
            DynamicButton(
              onPressed: controller.retryKycVerification,
              baseColor: AppColors.main,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 8,
                children: [
                  Text(
                    'auth.support_view.retry_button'.tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.light,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
