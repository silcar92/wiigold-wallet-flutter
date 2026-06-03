import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_auth_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_checkbox.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_terms_links.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? CONTROLLER
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/app/modules/register/controllers/register_controller.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

//? OTHERS
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/password_conditions_widget.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        controller.emailController.clear();
        Get.back();
      },
      appBar: DynamicAppBar(
        showAutoBackButton: true,
        backbuttomFunction: () {
          controller.emailController.clear();
          Get.back();
        },
      ),
      isContentCentered: true,
      body: RegisterPage(),
    );
  }
}

//? AUTH
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: 10,
      children: [
        DynamicDivider(height: 10),

        //? FORM TITLE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Text(
                  "register.register_view.title".tr,
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
            Text(
              "register.register_view.subtitle".tr,
              style: textTheme.titleMedium,
            ),
          ],
        ),

        DynamicDivider(height: 30),

        //? FROM CORE
        RegisterFormCore(),
      ],
    );
  }
}

class RegisterFormCore extends GetView<RegisterController> {
  const RegisterFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: DynamicForm(
        semanticSettings: FormSemantics(identifier: 'registerForm_step1'),
        formKey: controller.registerFormKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          children: [
            DynamicInput(
              semanticSettings: InputSemantics(
                identifier: 'email_registerForm_step1',
              ),
              label: 'register.register_view.form.emailInput'.tr,
              controller: controller.emailController,
              inputType: TextInputType.emailAddress,
              validationPatter: Validations.validationInputEmail,
              onTapEnter: (value) => {controller.validateRegisterForm()},
            ),

            DynamicDivider(height: 20),

            DynamicAuthInput(
              semanticSettings: PasswordSemantics(
                identifier: 'password_authForm_step2',
              ),
              label: "register.register_view.form.passwordInput".tr,
              controller: controller.passwordController,
              onTapEnter: (value) => {controller.validateRegisterForm()},
              validator: Validations.validationInputPass,
              showErrorText: false,
            ),

            const SizedBox(height: 8),

            PasswordConditionsWidget(controller: controller.passwordController),

            DynamicDivider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: DynamicTermsLinks(
                    value: controller.checkTerms,
                    prefixKey: 'register.terms_view.accept_prefix',
                    linkKey: 'register.terms_view.accept_link',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: DynamicTermsLinks(
                    value: controller.checkPrivacy,
                    prefixKey: 'register.terms_view.privacy_prefix',
                    linkKey: 'register.terms_view.privacy_link',
                    onLinkTap: () {
                      final financialController = Get.find<FinancialController>();
                      financialController.openPrivacyPolicy();
                    },
                  ),
                ),
              ],
            ),

            DynamicDivider(height: 40),

            Obx(
              () => DynamicButton(
                semanticSettings: ButtonSemantics(
                  identifier: 'submit_form_buttom',
                ),
                isDisabled: !controller.checkTerms.value || !controller.checkPrivacy.value,
                onPressed: controller.validateRegisterForm,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Text(
                      'register.register_view.form.submit_button'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.light,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            DynamicDivider(height: 120),
            //? LINKS
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "register.register_view.login_link_part1".tr,
                  style: textTheme.labelLarge,
                ),
                InkWell(
                  onTap: (() {
                    FocusScope.of(context).unfocus();

                    Get.offAllNamed(AppRoutes.LOGIN);
                  }),
                  child: Text(
                    "register.register_view.login_link_part2".tr,
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
