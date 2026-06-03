import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';

//? VALIDATIONS

//? WIDGETS

//? CONTROLLER

//? THEMES & IMAGES
import 'package:wiigold/app/modules/loan/controllers/loan_data_controller.dart';
import 'package:wiigold/app/modules/loan/widgets/loan_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class LoanDataView extends GetView<LoanDataController> {
  const LoanDataView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () => {
        Get.offAllNamed(
          AppRoutes.LOAN_REQUEST,
          parameters: {
            "data": jsonEncode({
              "amountUsd": controller.loan.amountUsd,
              "codeAsset": controller.loan.codeAsset,
            }),
          },
        ),
      },
      appBar: DynamicAppBar(
        showLogo: false,
        title: LoanAppbarTitle(),
        backbuttomFunction: () => {
          Get.offAllNamed(
            AppRoutes.LOAN_REQUEST,
            parameters: {
              "data": jsonEncode({
                "amountUsd": controller.loan.amountUsd,
                "codeAsset": controller.loan.codeAsset,
              }),
            },
          ),
        },
      ),
      onRefresh: controller.chargeData,
      body: LoanDataPage(),
    );
  }
}

class LoanDataPage extends GetView<LoanDataController> {
  const LoanDataPage({super.key});

  @override
  //? ROOT PAGE
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.displayLarge?.copyWith(height: 1),
                    children: [
                      TextSpan(text: 'loan.data_view.title_part1'.tr),
                      TextSpan(
                        text: 'loan.data_view.title_part2_highlight'.tr,
                        style: TextStyle(
                          color: AppColors.main,
                          fontWeight: FontWeight.w600,
                        ),
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
                child: Text(
                  style: textTheme.labelLarge,
                  'loan.data_view.security_notice'.tr,
                ),
              ),
            ],
          ),

          DynamicDivider(height: 25),

          LoanDataCore(),
        ],
      ),
    );
  }
}

class LoanDataCore extends GetView<LoanDataController> {
  const LoanDataCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: "loanDataForm"),
      formKey: controller.loanDataFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          DynamicInput(
            semanticSettings: InputSemantics(
              identifier: 'accountName_loanDataForm',
            ),
            label: 'loan.data_view.account_holder_name_label'.tr,
            controller: controller.accountNameController,
            inputType: TextInputType.text,
            validationPatter: (value) => Validations.validationInputName(
              value,
              minLength: 5,
              maxLength: 50,
            ),
          ),

          DynamicDivider(height: 20),

          DynamicNumeric(
            semanticSettings: NumericSemantics(
              identifier: 'accountNumber_loanDataForm',
            ),
            label: 'loan.data_view.account_number_label'.tr,
            controller: controller.accountNumberController,
            allowDecimals: false,
            validationPatter: (value) => Validations.validationInputNumericText(
              value,
              minLength: 5,
              maxLength: 15,
            ),
            max: 999999999999999,
            min: 10000,
            hint: "",
            disableNumericFormatter: true,
          ),

          DynamicDivider(height: 20),

          Obx(() {
            if (controller.bankName.value != '') {
              return DynamicInput(
                semanticSettings: InputSemantics(
                  identifier: 'bankName_loanDataForm',
                ),
                label: 'loan.data_view.bank_name_label'.tr,
                controller: controller.bankNameController,
                inputType: TextInputType.text,
                isDisabled: true,
              );
            } else {
              return DynamicDivider(height: 1);
            }
          }),

          DynamicDivider(height: 20),

          DynamicInput(
            semanticSettings: InputSemantics(
              identifier: 'swiftCode_loanDataForm',
            ),
            label: 'loan.data_view.swift_code_label'.tr,
            controller: controller.swiftCodeController,
            inputType: TextInputType.text,
            validationPatter: (value) => Validations.validateSwiftCode(value),
            onChanged: (value) => controller.changeSwiftCode(value),
          ),

          Obx(
            () => DynamicDropdownInput(
              semanticSettings: DropdownSemantics(
                identifier: 'loanTerm_loanDataForm',
              ),
              label: 'loan.data_view.interest_term_label'.tr,
              sourceSorted: false,
              items: controller.loanterms.map((t) {
                return DropdownItem(
                  value: "${t.uuid}",
                  label: 'loan.data_view.term_option_label'.trParams({
                    'days': t.termDays.toString(),
                    'rate': t.interestRate.toString(),
                  }),
                );
              }).toList(),
              value: controller.selectedTermId.value,
              onChanged: (termId) {
                controller.updateSelectedTerm(termId!);
              },
              validator: Validations.validationDropdown,
              dropdownSearchInputType: TextInputType.text,
              searchController: controller.termController,
              showIcons: true,
              searchable: true,
              hint: 'loan.data_view.select_term_hint'.tr,
            ),
          ),

          DynamicDivider(height: 75),

          DynamicButton(
            semanticSettings: ButtonSemantics(
              identifier: 'submit_loanDataForm',
            ),
            disabledColor: AppColors.dark2,
            isGradient: true,
            baseColor: AppColors.main,
            onPressed: controller.validateLoanDataForm,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'loan.data_view.continue_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
              ],
            ),
          ),

          DynamicDivider(height: 10),

          DynamicButton(
            semanticSettings: ButtonSemantics(identifier: 'back_loanDataForm'),
            borderColor: AppColors.main,
            baseColor: AppColors.transparent,
            onPressed: () => {Get.back()},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Icon(Icons.arrow_back, size: 20, color: AppColors.main),
                Text(
                  'loan.data_view.modify_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.main),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
