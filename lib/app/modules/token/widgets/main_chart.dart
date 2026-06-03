import 'package:flutter/material.dart';

//? CHARTS
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLER

//? THEME & IMAGES
import 'package:intl/intl.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/token/controllers/token_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class MainChart extends GetView<TokenController> {
  const MainChart({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget filterOptions() {
      return Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...controller.chartModeOptions.map(
                (otp) => Obx(
                  () => DynamicButton(
                    height: 30,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    baseColor: controller.currentChartMode.value == otp['value']
                        ? AppColors.dark3
                        : AppColors.light,
                    borderColor: AppColors.light,
                    onPressed: () {
                      controller.changeChartMode(otp['value']!);
                    },
                    child: Text(
                      otp['label']!,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: controller.currentChartMode.value == otp['value']
                            ? AppColors.dark
                            : AppColors.dark2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColors.light,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: 'token.main_chart.value_label'.tr,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "${controller.price.value} USD",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                style: textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: 'token.main_chart.date_label'.tr,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Obx(
              () => AspectRatio(
                aspectRatio: 1.75,
                child: LineChart(controller.getMainChart()),
              ),
            ),

            DynamicDivider(height: 10),

            filterOptions(),
          ],
        ),
      ),
    );
  }
}
