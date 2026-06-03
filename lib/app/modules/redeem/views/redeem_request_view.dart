import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
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
import 'package:wiigold/app/modules/home/widgets/balance_card.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_request_controller.dart';
import 'package:wiigold/app/modules/redeem/widgets/redeem_appbar_title.dart';
import 'package:wiigold/app/modules/redeem/widgets/redeem_balance_card.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? CONTROLLERS

//? THEME & IMAGES

//? WIDGETS

class RedeemRequestView extends GetView<RedeemRequestController> {
  const RedeemRequestView({super.key});

  @override
  //? ROOT WIDGE
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        Get.offAllNamed(AppRoutes.REDEEM_SELECTOR);
      },
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showAutoBackButton: true,
        backbuttomFunction: () {
          Get.offAllNamed(AppRoutes.REDEEM_SELECTOR);
        },
        title: RedeemAppbarTitle(),
      ),
      onRefresh: controller.chargeData,
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 40,
        bottom: 20,
      ),
      body: RedeemPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class RedeemPage extends GetView<RedeemRequestController> {
  const RedeemPage({super.key});

  @override
  //? ROOT PAGE
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: textTheme.displayLarge?.copyWith(height: 1),
                  children: [
                    TextSpan(text: 'redeem.request_view.title_part1'.tr),
                    TextSpan(
                      text: 'redeem.request_view.title_part2_highlight'.tr,
                      style: TextStyle(color: AppColors.main),
                    ),
                    TextSpan(
                      text: 'redeem.request_view.title_part3_highlight'.tr,
                    ),
                  ],
                ),
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
                'redeem.request_view.subtitle'.tr,
              ),
            ),
          ],
        ),

        DynamicDivider(height: 75),

        RedeemBalanceCard(),

        DynamicDivider(height: 75),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                style: textTheme.displaySmall,
                'redeem.request_view.enter_amount_label'.tr,
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
                  'redeem.request_view.request_limit_label'.tr,
                ),
              ),
              Flexible(
                child: Text(
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    color: AppColors.main,
                  ),
                  "${controller.tokenLimit.value} ${'redeem.request_view.grams_abbreviation'.tr}",
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
                'redeem.request_view.reminder_note'.tr,
              ),
            ),
          ],
        ),
        DynamicDivider(height: 50),
        DynamicForm(
          semanticSettings: FormSemantics(identifier: 'redeemAmountForm'),
          formKey: controller.amountRedeemRequestFormKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DynamicInputWithDropdown(
                dropdownSearchInputType: TextInputType.text,
                dropdownItems: [
                  DropdownItem(
                    value: "gr",
                    label: 'redeem.request_view.grams_abbreviation'.tr,
                  ),
                ],
                dropDisabled: true,
                dropdownValue: 'gr',
                dropdownChange: (selectedId) {},
                inputController: controller.quantityController,
                enableInteractiveSelection: false,
                max: controller.tokenLimit.value.toDouble(),
                decimals: 4,
                validator: (value) => Validations.validationInputNumeric(
                  value,
                  max: controller.tokenLimit.value.toDouble(),
                  min: 0.1,
                  disallowZero: true,
                ),
                inputChange: (value) {
                  controller.onAmountChanged(value);
                },
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
                      TextSpan(text: 'redeem.request_view.commission_label'.tr),
                      TextSpan(
                        text:
                            "${controller.comissionAmount.value.toHauvNumericString()} WGOLD",
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
                      controller.isBlocked.value ||
                      !controller.checkTerms.value,
                  disabledColor: AppColors.dark3,
                  isGradient: true,
                  baseColor: AppColors.main,
                  onPressed: controller.validateInsetAmountForm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 8,
                    children: [
                      Text(
                        'redeem.request_view.continue_button'.tr,
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
