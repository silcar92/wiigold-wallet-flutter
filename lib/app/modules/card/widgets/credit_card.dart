import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/modules/card/controllers/card_controller.dart';
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/theme/Responsive.dart';

class CreditCard extends GetView<CardController> {
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;

  final isDetailsVisible = false.obs;

  CreditCard({Key? key, this.cardNumber, this.expiryDate, this.cvv})
      : super(key: key);

  String _formatCardNumber(String? number) {
    if (number == null || number.length < 4) {
      return '**** **** **** ****';
    }
    if (!isDetailsVisible.value) {
      final lastFour = number.substring(number.length - 4);
      return '**** **** **** $lastFour';
    }
    return number.replaceAllMapped(
      RegExp(r".{4}"),
          (match) => "${match.group(0)} ",
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    final label =
        '\$${controller.availableBalance.value.toDouble().toHauvNumericString(decimals: 2)} USD';

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
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [AppColors.main, AppColors.main.withAlpha(220)],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/images/brand/logos/logotipo-mono.svg',
                    width: MediaQuery.of(context).size.width * 0.3,
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
                              fontSize: getAmountFontSize() * scaleFactor * 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'card.credit_card.card_number_label'.tr,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.main2,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _formatCardNumber(cardNumber),
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.light2,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () => isDetailsVisible.toggle(),
                          child: Icon(
                            isDetailsVisible.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const DynamicDivider(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'card.credit_card.valid_until_label'.tr,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.main2,
                                fontSize: 12,
                              ),
                            ),
                            Obx(
                                  () => Text(
                                isDetailsVisible.value
                                    ? (expiryDate ?? '--/--')
                                    : '**/**',
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppColors.light2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'card.credit_card.cvv_label'.tr,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.main2,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              isDetailsVisible.value ? (cvv ?? '---') : '***',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.light2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}