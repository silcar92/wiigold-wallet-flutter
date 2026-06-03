import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/theme/Colors.dart';

//? THEME & IMAGES

class SendAppbarTitle extends StatelessWidget implements PreferredSizeWidget {
  const SendAppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: 8,
      children: [
        Text(
          'send.view.appbar_title'.tr,
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
