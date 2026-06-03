import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_amount_changer.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:wiigold/app/modules/exchange/widgets/exchange_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? CONTROLLERS

//? THEMES & IMAGES

//? WIDGETS

class ConfirmExchangeView extends GetView<ExchangeController> {
  const ConfirmExchangeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () => {Get.offAllNamed(AppRoutes.EXCHANGE)},
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: ExchangeAppbarTitle(),
        backbuttomFunction: () => {Get.offAllNamed(AppRoutes.EXCHANGE)},
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      body: ExchangePage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.exchange,
      ),
    );
  }
}

class ExchangePage extends GetView<ExchangeController> {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 0.9),
            children: [TextSpan(text: 'exchange.confirm_view.title'.tr)],
          ),
        ),

        DynamicDivider(height: 75),

        Obx(
          () => DynamicAmountChanger(
            inputFrom: AmountChangeInput(
              label: 'exchange.confirm_view.from_label'.tr,
              currency:
                  controller.selectedTokenFrom.value?.asset_info?.name ?? '',
              value: controller.fromAmountController.text
                  .toDouble()
                  .toHauvNumericString(),
            ),
            inputTo: AmountChangeInput(
              label: 'exchange.confirm_view.to_label'.tr,
              currency:
                  controller.selectedTokenTo.value?.asset_info?.name ?? '',
              value: controller.toAmountController.text
                  .toDouble()
                  .toHauvNumericString(),
            ),
          ),
        ),

        DynamicDivider(height: 10),

        DynamicDivider(height: 75),

        DynamicButton(
          onPressed: controller.submitConfirmExchangeForm,
          baseColor: AppColors.main,
          isGradient: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'exchange.confirm_view.continue_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
              Icon(Icons.arrow_forward, color: AppColors.light),
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
              Icon(Icons.arrow_back, color: AppColors.main),
              Text(
                'exchange.confirm_view.return_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
