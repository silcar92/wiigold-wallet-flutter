import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wiigold/theme/Responsive.dart';

class DynamicLogo extends StatelessWidget implements PreferredSizeWidget {
  const DynamicLogo({super.key});

  @override
  Widget build(BuildContext context) {
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: 10 * scaleFactor,
      children: [
        SvgPicture.asset(
          'assets/images/brand/logos/logotipo.svg',
          height: 36 * scaleFactor,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => throw UnimplementedError();
}
