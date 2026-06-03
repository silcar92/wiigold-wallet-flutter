import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLER

//? THEMES & IMAGES

//? WIDGETS

import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/theme/Responsive.dart';

class BalanceCard extends GetView<HomeController> {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    final label =
        '\$${controller.availableBalance.value.toDouble().toHauvNumericString(
          decimals: 2,
        )} USD';

    double getAmountFontSize() {
      final length = label.length;

      if (length <= 7) return 42;
      if (length <= 9) return 38;
      if (length <= 12) return 34;
      if (length <= 15) return 30;
      if (length <= 18) return 26;

      return 28;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.75,
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
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.vertical,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/images/brand/logos/logotipo-mono.svg',
                        height: 30 * scaleFactor,
                      ),
                      GestureDetector(
                        onTap: controller.showQr,
                        child: Icon(
                          Icons.qr_code,
                          color: AppColors.light,
                          size: 28 * scaleFactor,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => RichText(
                          text: TextSpan(
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.dark,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '\$',
                                style: textTheme.displayMedium?.copyWith(
                                  color: AppColors.accent2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: getAmountFontSize() * scaleFactor,
                                ),
                              ),
                              TextSpan(
                                text: controller.availableBalance.value
                                    .toDouble()
                                    .toHauvNumericString(decimals: 2),
                                style: textTheme.displayMedium?.copyWith(
                                  color: AppColors.accent2,
                                  fontSize: getAmountFontSize() * scaleFactor,
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: ' USD',
                                style: textTheme.displaySmall?.copyWith(
                                  color: AppColors.accent2,
                                  fontSize:
                                      getAmountFontSize() * scaleFactor * 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Flex(
                direction: Axis.vertical,
                spacing: 6,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      Text(
                        'home.balance_card.my_address_label'.tr,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.light,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        border: Border.all(color: AppColors.light, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            Obx(
                              () => Expanded(
                                child: Text(
                                  controller.walletAddress.value.truncateText(
                                    24,
                                  ),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.light,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            DynamicButton(
                              semanticSettings: const ButtonSemantics(
                                identifier: 'copy',
                              ),
                              width: 70,
                              height: 30,
                              baseColor: Colors.transparent,
                              isGradient: false,
                              radius: 50,
                              onPressed: () => controller.copyAccountAddress(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                spacing: 2,
                                children: [
                                  Icon(
                                    Icons.file_copy,
                                    size: 12 * scaleFactor,
                                    color: AppColors.accent2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'home.balance_card.copy_button'.tr,

                                      style: textTheme.labelSmall?.copyWith(
                                        overflow: TextOverflow.fade,
                                        color: AppColors.accent2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              DynamicDivider(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => {Get.toNamed(AppRoutes.CARD)},
                    child: Text(
                      'home.balance_card.view_card_button'.tr,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.accent,
                        color: AppColors.accent,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.accent,
                    size: 14,
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
