import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_auth_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_reclaim_form_link.dart';

import 'package:wiigold/app/routers/app_routes.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/login/controllers/login_controller.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

//? OTHERS
import 'package:wiigold/app/common/utils/validations.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.closeApp,
      appBar: DynamicAppBar(showAutoBackButton: false, showLogo: true),
      isContentCentered: true,
      body: LoginForm(),
    );
  }
}

class LoginForm extends GetView<LoginController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                "login.title".tr,
                style: textTheme.displayLarge?.copyWith(
                  color: AppColors.dark,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text("login.subtitle".tr, style: textTheme.titleMedium),
            ),
          ],
        ),

        DynamicDivider(height: 30),

        LoginFormCore(),
      ],
    );
  }
}

class LoginFormCore extends GetView<LoginController> {
  const LoginFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: DynamicForm(
        semanticSettings: FormSemantics(identifier: 'loginForm_step1'),
        formKey: controller.loginFormKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          children: [
            DynamicInput(
              semanticSettings: InputSemantics(
                identifier: 'email_loginForm_step1',
              ),
              label: "login.form.emailInput".tr,
              controller: controller.emailController,
              inputType: TextInputType.emailAddress,
              validationPatter: Validations.validationInputEmail,
              onTapEnter: (value) => {controller.validateLoginForm()},
            ),

            DynamicDivider(height: 20),

            DynamicAuthInput(
              semanticSettings: PasswordSemantics(
                identifier: 'password_loginForm_step2',
              ),
              label: "login.form.passwordInput".tr,
              controller: controller.passController,
              onTapEnter: ((value) => controller.validateLoginForm()),
              enableBiometrics: false,
            ),

            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (() {
                    FocusScope.of(context).unfocus();

                    Get.offAllNamed(AppRoutes.RECOVERY);
                  }),
                  child: Text(
                    "login.recovery".tr,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            Obx(() {
              if (controller.loginError.value.isEmpty) {
                return const DynamicDivider(height: 60);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  controller.loginError.value,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.failure,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),

            DynamicButton(
              semanticSettings: ButtonSemantics(
                identifier: 'submit_loginForm_step1',
              ),
              width: double.infinity,
              disabledColor: AppColors.light2,
              onPressed: controller.validateLoginForm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 8,
                children: [
                  Text(
                    "login.form.submit".tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.light,
                    ),
                  ),
                ],
              ),
            ),

            RedirectClaimLink(showLink: controller.isAccountLocked ),

            DynamicDivider(height: 90),

            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("login.sing_up.link1".tr, style: textTheme.labelLarge),
                InkWell(
                  onTap: (() {
                    FocusScope.of(context).unfocus();

                    Get.offAllNamed(AppRoutes.REGISTER_TYPE);
                  }),
                  child: Text(
                    "login.sing_up.link2".tr,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
