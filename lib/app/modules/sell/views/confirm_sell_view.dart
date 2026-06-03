import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_amount_changer.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/sell/controllers/sell_controller.dart';
import 'package:wiigold/app/modules/sell/widgets/sell_appbar_title.dart';
import 'package:wiigold/app/modules/sell/widgets/sell_info.dart';
import 'package:wiigold/theme/Colors.dart';

//? CONTROLLERS

//? THEMES & IMAGES

//? MODELS

//? WIDGETS

class ConfirmSellView extends GetView<SellController> {
  const ConfirmSellView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: SellAppbarTitle(),
      ),
      isContentCentered: true,
      body: SellPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class SellPage extends GetView<SellController> {
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
            children: [TextSpan(text: 'sell.confirm_sell_view.title'.tr)],
          ),
        ),

        DynamicDivider(height: 75),

        //? FORM
        DynamicAmountChanger(
          inputFrom: AmountChangeInput(
            label: 'sell.confirm_sell_view.sell_label'.tr,
            currency: controller.selectedToken.value?.asset_info?.name ?? '',
            value: controller.soldAmountController.text,
          ),
          inputTo: AmountChangeInput(
            label: 'sell.confirm_sell_view.receive_label'.tr,
            currency: "USD",
            value: controller.payableAmountController.text,
          ),
          extra: SellInfo(),
        ),

        DynamicDivider(height: 10),

        DynamicDivider(height: 75),

        DynamicButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();

            controller.validateConfirmSell();
          },
          baseColor: AppColors.main,
          isGradient: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'sell.confirm_sell_view.submit_button'.tr,
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
                'sell.confirm_sell_view.back_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
