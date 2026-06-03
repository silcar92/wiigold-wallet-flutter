import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? THEMES & IMAGES
import 'package:wiigold/app/common/utils/extensions.dart';
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
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/sell/controllers/sell_controller.dart';
import 'package:wiigold/app/modules/sell/widgets/sell_appbar_title.dart';
import 'package:wiigold/app/modules/sell/widgets/sell_info.dart';
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

class SellView extends GetView<SellController> {
  const SellView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      onCustomBack: () {
        Get.back();
      },
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: SellAppbarTitle(),
        backbuttomFunction: () {
          Get.back();
        },
      ),
      onRefresh: controller.chargeData,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      body: SellPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class SellPage extends StatelessWidget {
  const SellPage({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? TITLE
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 0.9),
            children: [
              TextSpan(text: 'sell.sell_view.title_part1'.tr),

              TextSpan(
                text: 'sell.sell_view.title_part2_highlight'.tr,

                style: TextStyle(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 20),

        DynamicProgressIndicator(
          percent: 0.5,
          label: 'sell.sell_view.progress_label'.tr,
        ),

        DynamicDivider(height: 20),

        //? FORM
        SellFormCore(),
      ],
    );
  }
}

class SellFormCore extends GetView<SellController> {
  const SellFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: 'sellForm_step1'),
      formKey: controller.sellFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicDivider(height: 10),

          Text(
            'sell.sell_view.form.sell_label'.tr,
            style: textTheme.displaySmall?.copyWith(height: 1.5),
          ),

          Obx(() {
            final availableBalance =
                controller.selectedToken.value?.available?.toDouble() ?? 0.0;

            return DynamicInputWithDropdown<AssetBalance>(
              dropdownSearchInputType: TextInputType.text,
              dropdownItems: [controller.selectedToken.value]
                  .map(
                    (t) => DropdownItem<AssetBalance>(
                      value: t!,
                      label: t.asset_info!.name ?? '',
                      icon: buildAssetImage(
                        t.asset_info!.asset_image_url ?? '',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  )
                  .toList(),
              max: availableBalance,
              enableInteractiveSelection: false,
              validator: (value) => Validations.validationInputNumeric(
                value,
                max: availableBalance,
                min: 0.1,
                disallowZero: true,
              ),
              decimals: 4,
              dropDisabled: true,
              dropdownValue: controller.selectedToken.value,
              dropdownChange: (asset) {
                if (asset != null) {
                  controller.selectedToken.value = asset;
                  controller.onInputChange();
                }
              },
              inputController: controller.soldAmountController,
              inputChange: (value) {
                controller.onInputChange();
              },
              onTapEnter: (value) => controller.validateSellForm,
            );
          }),

          Obx(() {
            final availableBalance =
                controller.selectedToken.value?.available?.toDouble() ?? 0.0;

            return Flex(
              direction: Axis.vertical,
              children: [
                DynamicDivider(height: 10),
                RichText(
                  text: TextSpan(
                    style: textTheme.labelLarge?.copyWith(
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'sell.sell_view.form.available_balance_label'.tr,
                      ),
                      TextSpan(
                        text: availableBalance.toHauvNumericString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.main,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          DynamicDivider(height: 60),

          Text(
            'sell.sell_view.form.receive_label'.tr,
            style: textTheme.displaySmall?.copyWith(height: 1.5),
          ),

          Obx(
            () => DynamicInputWithDropdown(
              dropdownSearchInputType: TextInputType.text,
              dropdownIdentifier: 'purchaseCurrency_sellForm_step1',
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
              dropdownChange: (selectedId) {},
              inputController: controller.payableAmountController,
              inputChange: (value) {},
              dropDisabled: true,
              isDisabled: true,
            ),
          ),

          DynamicDivider(height: 20),

          SellInfo(),

          DynamicDivider(height: 60),

          Obx(
            () => DynamicButton(
              isDisabled: controller.isBlocked.value,
              onPressed: controller.validateSellForm,
              baseColor: AppColors.main,
              isGradient: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 8,
                children: [
                  Text(
                    'sell.sell_view.form.submit_button'.tr,
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
