import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/recovery/controllers/recovery_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';

//? OTHERS
import 'package:wiigold/app/common/utils/validations.dart';

class RecoveryView extends GetView<RecoveryController> {
  const RecoveryView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      backButtonBehavior: BackButtonBehavior.toLogin,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: true,
        backbuttomFunction: () {
          Get.offAllNamed(AppRoutes.LOGIN);
        },
      ),
      isContentCentered: true,
      body: RecoveryForm(),
    );
  }
}

//? RECOVERY
class RecoveryForm extends StatelessWidget {
  const RecoveryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //? FORM TITLE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Text(
                  "recovery.recovery_view.title_part1".tr,
                  style: textTheme.displayLarge?.copyWith(
                    color: AppColors.dark,
                    height: 1.1,
                  ),
                ),
                Text(
                  "recovery.recovery_view.title_part2".tr,
                  style: textTheme.displayLarge?.copyWith(height: 1.1),
                ),
              ],
            ),
          ],
        ),

        //? FORM SUBTITLE
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "recovery.recovery_view.subtitle".tr,
                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),

        DynamicDivider(height: 30),

        //? FROM CORE
        RecoveryFormCore(),
      ],
    );
  }
}

class RecoveryFormCore extends GetView<RecoveryController> {
  const RecoveryFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Form(
      key: controller.recoveryFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          DynamicInput(
            label: 'recovery.recovery_view.form.email_input'.tr,
            controller: controller.emailController,
            inputType: TextInputType.emailAddress,
            validationPatter: Validations.validationInputEmail,
          ),
          DynamicDivider(height: 60),
          DynamicButton(
            disabledColor: AppColors.main2,
            onPressed: controller.validateRecoveryForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'recovery.recovery_view.form.submit'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
