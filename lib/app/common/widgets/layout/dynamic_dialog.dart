import 'package:animated_confirm_dialog/animated_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/theme/Colors.dart';

//? THEME & IMAGES

Future<void> DynamicDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
  String? confirmButtonText,
  String? cancelButtonText,

  Color? confirmTextColor,
  Color? confirmButtonColor,

  Color? cancelTextColor,
  Color? cancelButtonColor,

  bool isDismissible = true,
}) async {
  showCustomDialog(
    context: context,
    title: title,
    titleColor: AppColors.light,
    message: message,
    messageColor: AppColors.light,

    backgroundColor: AppColors.dark,

    confirmButtonText:
        confirmButtonText ?? 'widgets.dynamic_app_scaffold.confirm'.tr,
    cancelButtonText:
        cancelButtonText ?? 'widgets.dynamic_app_scaffold.cancel'.tr,

    confirmButtonTextColor: confirmTextColor ?? AppColors.light,
    confirmButtonColor: confirmButtonColor ?? AppColors.dark2,

    cancelButtonTextColor: cancelTextColor ?? AppColors.light,
    cancelButtonColor: cancelButtonColor ?? AppColors.failure,

    onConfirm: onConfirm,
    onCancel: onCancel,
    isFlip: true,
  );
}
