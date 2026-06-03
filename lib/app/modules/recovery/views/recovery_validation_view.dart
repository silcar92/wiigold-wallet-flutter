import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_otp.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/recovery/controllers/recovery_controller.dart';
import 'package:wiigold/app/routers/app_pages.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

//? OTHERS
import 'package:wiigold/app/common/utils/validations.dart';

class RecoveryValidationView extends GetView<RecoveryController> {
  const RecoveryValidationView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      onCustomBack: () {
        Get.offAllNamed(AppRoutes.RECOVERY);
      },
      appBar: DynamicAppBar(
        showAutoBackButton: true,
        showLogo: false,
        backbuttomFunction: () {
          Get.offAllNamed(AppRoutes.RECOVERY);
        },
      ),
      isContentCentered: false,
      body: RecoveryValidationForm(),
      onReady: controller.startTimerToSendNewCode,
    );
  }
}

class RecoveryValidationForm extends StatelessWidget {
  const RecoveryValidationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 0.9),
            children: [
              TextSpan(
                text: 'recovery.recovery_validation_view.title_part1'.tr,
              ),
              TextSpan(text: '\n'),
              TextSpan(
                text: 'recovery.recovery_validation_view.title_part2'.tr,
                style: TextStyle(color: AppColors.dark),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "recovery.recovery_validation_view.subtitle".tr,
                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),

        DynamicDivider(height: 50),

        RecoveryValidationFormCore(),

        DynamicDivider(height: 50),
      ],
    );
  }
}

class RecoveryValidationFormCore extends GetView<RecoveryController> {
  const RecoveryValidationFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Form(
      key: controller.otpFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          DynamicOtp(
            semanticSettings: OtpSemantics(
              identifier: 'password_loginForm_stasdep2',
            ),
            validationPatter: Validations.validationInputPass,
            controller: controller.otpController,
            onTapEnter: (value) => controller.validateOtpForm,
          ),

          DynamicDivider(height: 50),

          DynamicButton(
            onPressed: controller.validateOtpForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'recovery.recovery_validation_view.form.submit'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
              ],
            ),
          ),

          DynamicDivider(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: controller.resendCode,
                child: Text(
                  'recovery.recovery_validation_view.resend_code'.tr,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.light,
                  ),
                ),
              ),

              Obx(
                () => Text(
                  "${controller.timeToSendNewCode}",
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.main),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
