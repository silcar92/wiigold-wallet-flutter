import 'package:flutter/material.dart';
import 'package:get/get.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

class ExchangeAppbarTitle extends StatelessWidget
    implements PreferredSizeWidget {
  const ExchangeAppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: 4,
      children: [
        Text(
          'exchange.view.appbar_title'.tr,
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
