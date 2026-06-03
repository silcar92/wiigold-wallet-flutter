import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? HANDLERS

//? MODELS

//? THEMES & IMAGES
import 'package:flutter_svg/svg.dart';
import 'package:wiigold/app/common/utils/functions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input_with_dropdown.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_progress_indicator.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_show_payment_method_info.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/buy/controllers/buy_controller.dart';
import 'package:wiigold/app/modules/buy/widgets/buy_appbar_title.dart';
import 'package:wiigold/app/modules/buy/widgets/buy_info.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

//? OTHERS

class BuyView extends GetView<BuyController> {
  const BuyView({super.key});

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
        controller.cleanForm();

        Get.back();
      },
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: BuyAppbarTitle(),
        backbuttomFunction: () {
          controller.cleanForm();

          Get.back();
        },
      ),
      onRefresh: controller.chargeData,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      body: BuyPage(),
      onReady: controller.handleInitialParams,
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class BuyPage extends StatelessWidget {
  const BuyPage({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 0.9),
            children: [
              TextSpan(text: 'buy.buy_view.title_part1'.tr),
              TextSpan(
                text: 'buy.buy_view.title_part2_highlight'.tr,
                style: TextStyle(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 20),

        DynamicProgressIndicator(
          percent: 0.25,
          label: "1/4",
          labelStyle: textTheme.titleLarge?.copyWith(
            color: AppColors.dark2,
            fontWeight: FontWeight.w600,
          ),
        ),

        DynamicDivider(height: 40),

        //? FORM
        BuyFormCore(),
      ],
    );
  }
}

class BuyFormCore extends GetView<BuyController> {
  const BuyFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: 'buyForm_step1'),
      formKey: controller.buyFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'buy.buy_view.form.for_label'.tr,
            style: textTheme.displaySmall?.copyWith(height: 1.5),
          ),

          Obx(
            () => DynamicInputWithDropdown<AssetBalance>(
              dropdownSearchInputType: TextInputType.text,
              dropdownItems: [controller.selectedToken.value]
                  .map(
                    (t) => DropdownItem<AssetBalance>(
                      value: t!,
                      label: t.asset_info!.name ?? '',
                      icon: buildAssetImage(
                        t.asset_info!.asset_image_url ?? '',
                      ),
                    ),
                  )
                  .toList(),
              isDisabled: false,
              enableInteractiveSelection: false,
              dropDisabled: true,
              max: 1000.0000,
              validator: (value) => Validations.validationInputNumeric(
                value,
                max: 1000.0000,
                min: 0.1,
                disallowZero: true,
              ),
              decimals: 4,
              dropdownValue: controller.selectedToken.value,
              dropdownChange: (value) {},
              inputController: controller.receivableAmountController,
              inputChange: (value) {
                controller.onInputChange();
              },
              onTapEnter: (value) => controller.validateBuyForm,
            ),
          ),

          DynamicDivider(height: 60),

          Text(
            'buy.buy_view.form.you_will_pay_label'.tr,
            style: textTheme.displaySmall?.copyWith(height: 1.5),
          ),

          Obx(() {
            return DynamicInputWithDropdown(
              dropdownSearchInputType: TextInputType.text,
              dropdownIdentifier: 'purchaseCurrency_buyForm_step1',
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
              dropdownValue: controller.currencyTarget.value,
              decimals: 2,

              dropdownChange: (selectedId) {},
              inputController: controller.payableAmountController,
              inputChange: (value) {
                controller.onInputChange();
              },
              dropDisabled: true,
              isDisabled: true,
            );
          }),

          DynamicDivider(height: 20),

          BuyInfo(),

          DynamicDivider(height: 60),

          Obx(
            () => DynamicButton(
              isDisabled: controller.isBlocked.value,
              onPressed: controller.validateBuyForm,
              isGradient: true,
              baseColor: AppColors.main,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 8,
                children: [
                  Text(
                    'buy.buy_view.form.submit_button'.tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.light,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
