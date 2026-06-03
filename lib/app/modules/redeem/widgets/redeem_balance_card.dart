import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_request_controller.dart';
import 'package:wiigold/theme/Colors.dart';

//? CONTROLLER

//? THEMES & IMAGES

//? WIDGETS
import 'package:wiigold/theme/Responsive.dart';

class RedeemBalanceCard extends GetView<RedeemRequestController> {
  const RedeemBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [AppColors.main.withAlpha(220), AppColors.main],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.vertical,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "redeem.balance_card.your_balance".tr,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.light,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  DynamicDivider(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          controller.availableBalance.value,
                          style: textTheme.displayMedium?.copyWith(
                            color: AppColors.accent2,
                            fontSize: 44 * scaleFactor,
                            height: 1.25,
                          ),
                        ),
                      ),

                      SizedBox(width: 10 * scaleFactor),

                      Obx(
                        () => Text(
                          controller.selectedToken.value?.asset_info?.name ??
                              '',
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.accent2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              DynamicDivider(height: 10),

              Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          "${controller.mineralBalance.value} ${'redeem.balance_card.grams_abbreviation'.tr}",
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.accent2,
                          ),
                        ),
                      ),

                      Text(
                        "redeem.balance_card.gold_equivalent".tr,
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.light,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          "\$${controller.usdBalance.value} USD",
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.accent2,
                          ),
                        ),
                      ),

                      Text(
                        "redeem.balance_card.dollar_equivalent".tr,
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.light,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
