import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_auth_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/recovery/controllers/recovery_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

//? OTHERS
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/password_conditions_widget.dart';

class RecoveryNewpassView extends GetView<RecoveryController> {
  const RecoveryNewpassView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        controller.clearAllForm();

        Get.offAllNamed(AppRoutes.RECOVERY);
      },
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(
        showAutoBackButton: true,
        showLogo: false,
        backbuttomFunction: () {
          controller.clearAllForm();

          Get.offAllNamed(AppRoutes.RECOVERY);
        },
      ),

      body: NewPassForm(),
    );
  }
}

class NewPassForm extends StatelessWidget {
  const NewPassForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "recovery.new_pass_view.title_part1".tr,
              style: textTheme.displayLarge?.copyWith(height: 1.1),
            ),
            Text(
              "recovery.new_pass_view.title_part2".tr,
              style: textTheme.displayLarge?.copyWith(
                height: 1.1,
                color: AppColors.dark,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "recovery.new_pass_view.subtitle".tr,
                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),

        DynamicDivider(height: 35),

        NewPassFormCore(),
      ],
    );
  }
}

class NewPassFormCore extends GetView<RecoveryController> {
  const NewPassFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      formKey: controller.newPassFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          DynamicAuthInput(
            semanticSettings: PasswordSemantics(
              identifier: 'password_loginForm_steasdp2',
            ),
            controller: controller.newPassController1,
            enableBiometrics: false,
            label:
                'recovery.new_pass_view.form.password_input'.tr, // TRADUCCION
            validator: Validations.validationInputPass,
            showErrorText: false,
          ),

          const SizedBox(height: 8),

          PasswordConditionsWidget(controller: controller.newPassController1),

          DynamicDivider(height: 40),

          DynamicAuthInput(
            semanticSettings: PasswordSemantics(
              identifier: 'password_loginForm_stqwep2',
            ),
            controller: controller.newPassController2,
            enableBiometrics: false,
            label: 'recovery.new_pass_view.form.password_repeat_input'
                .tr, // TRADUCCION
            validator: Validations.validationInputPass,
          ),

          DynamicDivider(height: 75),

          DynamicButton(
            onPressed: controller.validateNewPassForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'recovery.new_pass_view.form.submit'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
