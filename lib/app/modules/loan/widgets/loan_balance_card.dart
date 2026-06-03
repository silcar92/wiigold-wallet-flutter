import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';

//? CONTROLLER

//? THEMES & IMAGES

//? WIDGETS
import 'package:wiigold/app/modules/loan/controllers/loan_request_controller.dart';
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/theme/Responsive.dart';

class LoanBalanceCard extends GetView<LoanRequestController> {
  LoanBalanceCard({super.key});

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
                        "loan.balance_card.your_balance".tr,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.light,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                      Text(
                        controller.selectedToken.value?.asset_info?.name ?? '',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.accent2,
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
                          "${controller.goldBalance.value} ${'loan.balance_card.grams_abbreviation'.tr}",
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.accent2,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),

                      Text(
                        "loan.balance_card.gold_equivalent".tr,
                        style: textTheme.bodySmall?.copyWith(
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
                          overflow: TextOverflow.fade,
                        ),
                      ),

                      Text(
                        "loan.balance_card.dollar_equivalent".tr,
                        style: textTheme.bodySmall?.copyWith(
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
