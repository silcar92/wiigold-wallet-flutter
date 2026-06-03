import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/functions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input_with_dropdown.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:wiigold/app/modules/exchange/widgets/exchange_appbar_title.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class ExchangeView extends GetView<ExchangeController> {
  const ExchangeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      onCustomBack: () {
        Get.toNamed(AppRoutes.HOME);
      },
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: ExchangeAppbarTitle(),
        backbuttomFunction: () async {
          Get.toNamed(AppRoutes.HOME);
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      body: ExchangePage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.exchange,
      ),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [DynamicDivider(height: 20), ExchangeFormCore()],
    );
  }
}

class ExchangeFormCore extends GetView<ExchangeController> {
  const ExchangeFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget exchangeInfo() {
      return Flex(
        direction: Axis.vertical,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(
                    () => Text(
                      'exchange.view.value_in_usd'.trParams({
                        'value': controller.valueConvertion.value
                            .toHauvNumericString(),
                      }),
                      textAlign: TextAlign.end,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
                    ),
                  ),
                  Obx(
                    () => Text(
                      'exchange.view.commission'.trParams({
                        'commission': controller.comission.value
                            .toHauvNumericString(),
                        'tokenName':
                            controller
                                .selectedTokenFrom
                                .value
                                ?.asset_info
                                ?.name ??
                            '',
                      }),
                      textAlign: TextAlign.end,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
                    ),
                  ),
                  Obx(
                    () => Text(
                      'exchange.view.rate'.trParams({
                        'rate': controller.rateConvertion.value
                            .toHauvNumericString(),
                      }),
                      textAlign: TextAlign.end,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: 'exchangeForm_step1'),
      formKey: controller.exchangeFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: textTheme.displayLarge,
              children: [
                TextSpan(text: 'exchange.view.title_part1'.tr),
                TextSpan(
                  text: 'exchange.view.title_part2'.tr,
                  style: TextStyle(color: AppColors.main),
                ),
                TextSpan(text: 'exchange.view.title_part3'.tr),
              ],
            ),
          ),

          DynamicDivider(height: 10),

          Obx(() {
            final availableBalance =
                controller.selectedTokenFrom.value?.available?.toDouble() ??
                0.0;

            return DynamicInputWithDropdown<AssetBalance>(
              dropdownSearchInputType: TextInputType.text,
              dropdownItems: controller.tokens
                  .where(
                    (t) =>
                        t.asset_code !=
                        controller.selectedTokenTo.value?.asset_code,
                  )
                  .map(
                    (t) => DropdownItem<AssetBalance>(
                      value: t,
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
              dropdownValue: controller.selectedTokenFrom.value,
              dropdownChange: (asset) {
                if (asset != null) {
                  controller.isBlocked.value = true;

                  controller.selectedTokenFrom.value = asset;
                  controller.onInputChange();
                }
              },
              inputController: controller.fromAmountController,
              inputChange: (value) {
                controller.isBlocked.value = true;

                controller.onInputChange();
              },
            );
          }),

          Obx(() {
            final availableBalance =
                controller.selectedTokenFrom.value?.available?.toDouble() ??
                0.0;

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
                      TextSpan(text: 'exchange.view.available_balance'.tr),
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

          Text('exchange.view.for_label'.tr, style: textTheme.displayLarge),

          DynamicDivider(height: 10),

          Obx(() {
            return DynamicInputWithDropdown<AssetBalance>(
              dropdownSearchInputType: TextInputType.text,
              dropdownItems: controller.tokens
                  .where(
                    (t) =>
                        t.asset_code !=
                        controller.selectedTokenFrom.value?.asset_code,
                  )
                  .map(
                    (t) => DropdownItem<AssetBalance>(
                      value: t,
                      label: t.asset_info!.name ?? '',
                      icon: buildAssetImage(
                        t.asset_info!.asset_image_url ?? '',
                      ),
                    ),
                  )
                  .toList(),
              max: 99999999.9999,
              enableInteractiveSelection: false,
              inputDisabled: true,
              dropdownValue: controller.selectedTokenTo.value,
              dropdownChange: (asset) {
                if (asset != null) {
                  controller.isBlocked.value = true;

                  controller.selectedTokenTo.value = asset;
                  controller.onInputChange();
                }
              },
              inputController: controller.toAmountController,
              inputChange: (value) {
                controller.isBlocked.value = true;

                controller.onInputChange();
              },
            );
          }),

          DynamicDivider(height: 20),

          exchangeInfo(),

          DynamicDivider(height: 80),

          Obx(
            () => DynamicButton(
              isDisabled: controller.isBlocked.value,
              onPressed: controller.validateExchangeForm,
              isGradient: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'exchange.view.continue_button'.tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.light,
                    ),
                  ),
                  SizedBox(width: 8),
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
