import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

class RedeemAppbarTitle extends StatelessWidget implements PreferredSizeWidget {
  const RedeemAppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: 8,
      children: [
        Text(
          'redeem.appbar_title.title'.tr,
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
  Size get preferredSize => throw UnimplementedError();
}
