import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_amount_changer.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_progress_indicator.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/buy/controllers/buy_controller.dart';
import 'package:wiigold/app/modules/buy/widgets/buy_appbar_title.dart';
import 'package:wiigold/app/modules/buy/widgets/buy_info.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? THEMES & IMAGES

//? MODELS

//? WIDGETS

class ConfirmBuyView extends StatelessWidget {
  const ConfirmBuyView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final RxBool isLoading = false.obs;

    return DynamicAppScaffold(
      isLoading: isLoading,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        Get.back();
      },
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: BuyAppbarTitle(),
        backbuttomFunction: () {
          Get.back();
        },
      ),
      body: BuyPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class BuyPage extends GetView<BuyController> {
  const BuyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 0.9),
            children: [
              TextSpan(text: 'buy.confirm_buy_view.title_part1'.tr),
              TextSpan(
                text: 'buy.confirm_buy_view.title_part2_highlight'.tr,
                style: TextStyle(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 20),

        DynamicProgressIndicator(
          percent: 0.5,
          label: "2/4",
          labelStyle: textTheme.titleLarge?.copyWith(
            color: AppColors.dark2,
            fontWeight: FontWeight.w600,
          ),
        ),

        DynamicDivider(height: 75),

        //? FORM
        DynamicAmountChanger(
          inputFrom: AmountChangeInput(
            label: 'buy.confirm_buy_view.pay_label'.tr,
            currency: "USD",
            value: controller.payableAmountController.text
                .toHauvNumericString(),
          ),
          inputTo: AmountChangeInput(
            label: 'buy.confirm_buy_view.for_label'.tr,
            currency: controller.selectedToken.value?.asset_info?.name ?? '',
            value: controller.receivableAmountController.text,
          ),
          extra: BuyInfo(),
        ),

        DynamicDivider(height: 75),

        DynamicButton(
          onPressed: () {
            controller.submitConfirmBuyForm();
          },
          isGradient: true,
          baseColor: AppColors.main,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'buy.confirm_buy_view.submit_button'.tr,
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
                'buy.confirm_buy_view.back_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
