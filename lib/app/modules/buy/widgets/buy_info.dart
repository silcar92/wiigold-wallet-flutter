import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/modules/buy/controllers/buy_controller.dart';
import 'package:wiigold/theme/Colors.dart';

//? THEME & IMAGES

class BuyInfo extends GetView<BuyController> implements PreferredSizeWidget {
  const BuyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => Text(
                'buy.buy_info.rate_label'.tr.replaceAll(
                  '@rate',
                  controller.rateConvertion.value.toHauvNumericString(
                    decimals: 2,
                  ),
                ),
                textAlign: TextAlign.end,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => Text(
                'buy.buy_info.commission_label'.tr
                    .replaceAll(
                      '@commission',
                      controller.comission.value.toHauvNumericString(
                        decimals: 2,
                      ),
                    )
                    .replaceAll('@tokenName', 'USD'),
                textAlign: TextAlign.end,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.accent),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
