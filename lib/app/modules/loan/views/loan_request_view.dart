import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/functions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_checkbox.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input_with_dropdown.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_terms_links.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';

//? CONTROLLERS

//? THEME & IMAGES

//? WIDGETS
import 'package:wiigold/app/modules/loan/controllers/loan_request_controller.dart';
import 'package:wiigold/app/modules/loan/widgets/loan_balance_card.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class LoanRequestView extends GetView<LoanRequestController> {
  const LoanRequestView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () => {Get.offAllNamed(AppRoutes.LOAN_SELECTOR)},
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: true,
        showAutoBackButton: true,
        showActions: true,
        backbuttomFunction: () => {Get.offAllNamed(AppRoutes.LOAN_SELECTOR)},
      ),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 40,
        bottom: 20,
      ),
      body: LoanPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class LoanPage extends GetView<LoanRequestController> {
  const LoanPage({super.key});

  @override
  //? ROOT PAGE
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.displayLarge?.copyWith(height: 1),
                children: [
                  TextSpan(text: 'loan.request_view.title_part1'.tr),
                  TextSpan(
                    text: 'loan.request_view.title_part2'.tr,
                    style: TextStyle(color: AppColors.main),
                  ),
                ],
              ),
            ),
          ],
        ),
        DynamicDivider(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                style: textTheme.labelLarge,
                'loan.request_view.security_notice'.tr,
              ),
            ),
          ],
        ),
        DynamicDivider(height: 75),

        LoanBalanceCard(),

        DynamicDivider(height: 75),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                style: textTheme.displaySmall,
                'loan.request_view.enter_amount_label'.tr,
              ),
            ),
          ],
        ),
        DynamicDivider(height: 25),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                  'loan.request_view.request_limit_label'.tr,
                ),
              ),
              Flexible(
                child: Text(
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    color: AppColors.main,
                  ),
                  "\$${controller.usdLimit.value} USD",
                ),
              ),
            ],
          ),
        ),
        DynamicDivider(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.dark2,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
                'loan.request_view.deposit_time_notice'.tr,
              ),
            ),
          ],
        ),

        DynamicDivider(height: 50),

        DynamicForm(
          semanticSettings: FormSemantics(identifier: 'loanAmountForm'),
          formKey: controller.amountLoanRequestFormKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => DynamicInputWithDropdown(
                  dropdownSearchInputType: TextInputType.text,
                  dropdownItems: [
                    DropdownItem(
                      value: "usd",
                      label: 'USD',
                      icon: buildAssetImage(
                        "assets/images/icons/usd.svg",
                        width: 35,
                        height: 35,
                        isNetwork: false,
                      ),
                    ),
                  ],
                  dropDisabled: true,
                  dropdownValue: 'usd',
                  dropdownChange: (selectedId) {},
                  inputController: controller.amountController,
                  enableInteractiveSelection: false,
                  max: controller.usdLimit.value.toDouble(),
                  decimals: 2,
                  validator: (value) => Validations.validationInputNumeric(
                    value,
                    max: controller.usdLimit.value.toDouble(),
                    min: 0.1,
                    disallowZero: true,
                  ),
                  inputChange: (value) {
                    controller.onAmountChanged(value);
                  },
                ),
              ),

              DynamicDivider(height: 10),
              Obx(
                () => RichText(
                  text: TextSpan(
                    style: textTheme.labelLarge?.copyWith(
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'loan.request_view.collateral_required_label'.tr,
                      ),
                      TextSpan(
                        text:
                            "${controller.collateralAmount.value.toHauvNumericString()} ${controller.selectedToken.value?.asset_info?.name ?? ''}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.main2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DynamicDivider(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: DynamicTermsLinks(
                      value: controller.checkTerms,
                      prefixKey: 'loan.request_view.accept_terms.prefix',
                      linkKey: 'loan.request_view.accept_terms.link',
                    ),
                  ),
                ],
              ),
              DynamicDivider(height: 10),
              Obx(
                () => DynamicButton(
                  isDisabled:
                      !controller.checkTerms.value ||
                      controller.isBlocked.value == true,
                  isGradient: true,
                  onPressed: controller.validateInsetAmountForm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 8,
                    children: [
                      Text(
                        'loan.request_view.continue_button'.tr,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.light,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
