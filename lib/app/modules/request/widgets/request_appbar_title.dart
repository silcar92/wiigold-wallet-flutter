import 'package:flutter/material.dart';
import 'package:get/get.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

class RequestAppbarTitle extends StatelessWidget
    implements PreferredSizeWidget {
  const RequestAppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: 8,
      children: [
        Text(
          'request.view.appbar_title'.tr,
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
