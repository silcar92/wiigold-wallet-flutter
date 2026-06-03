import 'package:flutter/material.dart';
import 'package:wiigold/theme/Responsive.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

TextTheme createAppTextTheme(BuildContext context) {
  final double scaleFactor = AppResponsive.calculateScaleFactor(context);

  return TextTheme(
    //? DISPLAY
    displayLarge: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 52 * scaleFactor,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 34 * scaleFactor,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 22 * scaleFactor,
      fontWeight: FontWeight.bold,
    ),

    //? HEADLINE
    headlineLarge: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 22 * scaleFactor,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 18 * scaleFactor,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.w400,
    ),

    //? TITLE
    titleLarge: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 20 * scaleFactor,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 18 * scaleFactor,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.w400,
    ),

    //? BODY
    bodyLarge: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 12 * scaleFactor,
      fontWeight: FontWeight.normal,
    ),

    //? LABEL
    labelLarge: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 12 * scaleFactor,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      color: AppColors.dark,
      fontFamily: 'Anuphan',
      fontSize: 10 * scaleFactor,
      fontWeight: FontWeight.w400,
    ),
  );
}
