import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/functions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_datetime.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_image_picker.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_show_payment_method_info.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_payment_controller.dart';
import 'package:wiigold/app/modules/loan/widgets/loan_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? Controller

//? THEME & IMAGES

//? WIDGETS

//? OTHERS

class LoanPaymentDataView extends GetView<LoanPaymentController> {
  const LoanPaymentDataView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () => {Get.offAllNamed(AppRoutes.LOAN_PAYMENT_INFO)},
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showAutoBackButton: true,
        title: LoanAppbarTitle(),
        backbuttomFunction: () => {Get.offAllNamed(AppRoutes.LOAN_PAYMENT_INFO)},
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      body: LoanPaymentPage(),
      bottomNavigationBar: DynamicBottomNavigation(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class LoanPaymentPage extends GetView<LoanPaymentController> {
  const LoanPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: 10,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 1),
            children: [
              TextSpan(text: 'loan.payment_view.method_form.title_part1'.tr),
              TextSpan(
                text: 'loan.payment_view.method_form.title_part2_highlight'.tr,
                style: textTheme.displayLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
        DynamicDivider(height: 40),
        DynamicForm(
          formKey: controller.paymentMethodFormKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DynamicImagePickerInput(
                label: 'loan.payment_view.method_form.payment_proof_label'.tr,
                controller: controller.proofImageController,
              ),

              DynamicDivider(height: 20),

              DynamicInput(
                label:
                    'loan.payment_view.method_form.payment_reference_label'.tr,
                controller: controller.proofController,
                inputType: TextInputType.text,
                validationPatter: (value) => Validations.validationInputText(
                  value,
                  minLength: 5,
                  maxLength: 20,
                  additionalAllowedChars: ['-'],
                ),
              ),

              DynamicDivider(height: 20),

              DynamicDateTime(
                controller: controller.paymentDateController,
                label: 'loan.payment_view.method_form.payment_date_label'.tr,
              ),

              DynamicDivider(height: 20),

              DynamicInput(
                label: 'loan.payment_view.method_form.email_label'.tr,
                controller: controller.emailController,
                inputType: TextInputType.text,
                validationPatter: (value) =>
                    Validations.validationInputEmail(value, notRequiered: true),
              ),

              DynamicDivider(height: 50),

              DynamicButton(
                baseColor: AppColors.main,
                isGradient: true,

                onPressed: controller.validatePaymentMethodForm,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Text(
                      'loan.payment_view.method_form.pay_button'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.light,
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
                  ],
                ),
              ),

              DynamicDivider(height: 10),

              DynamicButton(
                onPressed: () {
                  Get.back();
                },
                baseColor: AppColors.transparent,
                borderColor: AppColors.main,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Icon(Icons.arrow_back, size: 20, color: AppColors.main),
                    Text(
                      'loan.payment_view.method_form.back_button'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
