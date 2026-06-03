import 'package:flutter/material.dart';

import 'package:wiigold/main.dart';

import 'package:responsive_framework/responsive_framework.dart';

const String MOBILE_SMALL_BREAKPOINT = "MOBILE_SMALL";

class DynamicDivider extends StatelessWidget {
  final double height;

  const DynamicDivider({super.key, this.height = 1.0});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    double scaleFactor = 1.0;

    if (responsive.smallerOrEqualTo(MOBILE_SMALL_BREAKPOINT)) {
      scaleFactor = 0.35;
    } else if (responsive.equals(MOBILE_BREAKPOINT)) {
      scaleFactor = 0.6;
    } else if (responsive.equals(TABLET_BREAKPOINT)) {
      scaleFactor = 0.8;
    }

    return SizedBox(height: height * scaleFactor);
  }
}
