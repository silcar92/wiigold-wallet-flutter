import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_payment_controller.dart';
import 'package:wiigold/app/modules/loan/widgets/loan_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? Controller

//? THEME & IMAGES

//? WIDGETS

//? OTHERS

class LoanPaymentView extends GetView<LoanPaymentController> {
  const LoanPaymentView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        Get.offAllNamed(
          AppRoutes.LOAN_DETAIL,
          parameters: {
            "data": jsonEncode({
              "loan_reference": controller.loanReference.value,
            }),
          },
        );
      },
      scaffoldKey: scaffoldKey,
      onReady: controller.handleInitialParams,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showAutoBackButton: true,
        title: LoanAppbarTitle(),
        backbuttomFunction: () {
          Get.offAllNamed(
            AppRoutes.LOAN_DETAIL,
            parameters: {
              "data": jsonEncode({
                "loan_reference": controller.loanReference.value,
              }),
            },
          );
        },
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
              TextSpan(text: 'loan.payment_view.amount_form.title_part1'.tr),
              TextSpan(
                text: 'loan.payment_view.amount_form.title_part2_highlight'.tr,
                style: textTheme.displayLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
        DynamicForm(
          formKey: controller.paymentAmountFormKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => DynamicNumeric(
                  label: '',
                  disableNumericFormatter: false,
                  enableInteractiveSelection: false,
                  controller: controller.amountController,
                  allowDecimals: true,
                  maxDecimals: 2,
                  min: 0,
                  inputStyle: textTheme.displayMedium,
                  inputDecoration: InputDecoration(
                    hintText: 'loan.payment_view.amount_form.amount_hint'.tr,
                    hintStyle: textTheme.displayMedium?.copyWith(
                      color: AppColors.dark2,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark2, width: 1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark2, width: 1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.dark2, width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.failure),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.failure),
                    ),
                    errorStyle: textTheme.bodyMedium?.copyWith(
                      height: .75,
                      fontWeight: FontWeight.w500,
                      color: AppColors.failure,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 16.0,
                    ),
                    isDense: true,
                  ),
                  sufix: DynamicButton(
                    width: 40,
                    onPressed: controller.setAllAmount,
                    baseColor: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 2,
                      children: [
                        Text(
                          'loan.payment_view.amount_form.max_button'.tr,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.main,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isDisabled: false,
                  max: controller.remainingAmount.value,
                  validationPatter: (value) =>
                      Validations.validationInputNumeric(
                        value,
                        min: 0.01,
                        max: controller.remainingAmount.value,
                        disallowZero: true,
                      ),
                ),
              ),
              Obx(
                () => RichText(
                  text: TextSpan(
                    style: textTheme.labelLarge?.copyWith(
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'loan.payment_view.amount_form.remaining_debt_label'
                                .tr,
                      ),
                      TextSpan(
                        text:
                            "${controller.remainingAmount.value.toHauvNumericString(decimals: 2)} USD",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.main,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        DynamicDivider(height: 100),
        DynamicButton(
          onPressed: controller.validatePaymentAmountForm,
          isGradient: true,
          baseColor: AppColors.main,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'loan.payment_view.amount_form.continue_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
              Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
            ],
          ),
        ),
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
                'loan.payment_view.amount_form.back_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
