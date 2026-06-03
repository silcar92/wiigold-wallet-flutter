import 'package:get/get.dart';

import 'package:flutter/material.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

class SellAppbarTitle extends StatelessWidget implements PreferredSizeWidget {
  const SellAppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: 4,
      children: [
        Text(
          'sell.appbar.title'.tr,
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.main,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
