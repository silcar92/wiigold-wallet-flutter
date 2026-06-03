import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';

//? THEME & IMAGES
import 'package:wiigold/app/modules/sell/controllers/sell_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class SellInfo extends GetView<SellController> implements PreferredSizeWidget {
  const SellInfo({super.key});

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
                'sell.sell_info.rate_label'.tr.replaceAll(
                  '@rate',
                  controller.rateConvertion.value.toHauvNumericString(),
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
                'sell.sell_info.commission_label'.tr
                    .replaceAll(
                      '@commission',
                      controller.comission.value.toHauvNumericString(),
                    )
                    .replaceAll(
                      '@tokenName',
                      controller.selectedToken.value?.asset_info?.name ?? '',
                    ),
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
