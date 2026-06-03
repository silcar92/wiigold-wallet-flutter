import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class RedirectClaimLink extends StatelessWidget {
  final RxBool showLink;

  const RedirectClaimLink({Key? key, required this.showLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!showLink.value) {
        return const SizedBox.shrink();
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.CLAIM),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                spacing: 4,
                children: [
                  Text(
                    'widgets.redirect_clain_form.part_1'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.dark2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text(
                    'widgets.redirect_clain_form.part_2'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.main,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
