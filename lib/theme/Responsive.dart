import 'package:flutter/material.dart';

//? RESPONSIVE FRAMEWORK
import 'package:responsive_framework/responsive_framework.dart';

class AppResponsive {
  static double calculateScaleFactor(BuildContext context) {
    final responsive = ResponsiveBreakpoints.of(context);
    double scaleFactor = 1.0;

    if (responsive.smallerOrEqualTo("MOBILE_SMALL")) {
      scaleFactor = 0.9;
    }

    return scaleFactor;
  }
}
