import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

class BuyAppbarTitle extends StatelessWidget implements PreferredSizeWidget {
  const BuyAppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: 4,
      children: [
        Text(
          'buy.appbar.title'.tr,
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
