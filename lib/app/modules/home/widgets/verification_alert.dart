import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/dynamic_logo.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? CONTROLLER

//? THEMES & IMAGES

//? WIDGETS
import 'package:wiigold/theme/Colors.dart';

class VerificationAlert extends GetView<HomeController> {
  final String label;

  const VerificationAlert({super.key, this.label = ''});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.dark2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              //? LOGO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [DynamicLogo()],
              ),

              DynamicDivider(height: 40),

              //? TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      'home.verification_alert.welcome_title'.tr,

                      style: textTheme.displayMedium?.copyWith(height: 1.1),
                    ),
                  ),
                ],
              ),

              //? SUBTITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      'home.verification_alert.welcome_subtitle'.tr,

                      style: textTheme.titleMedium,
                    ),
                  ),
                ],
              ),

              DynamicDivider(height: 60),

              DynamicButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.AUTH);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Text(
                      'home.verification_alert.continue_button'.tr,

                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.dark,
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 20, color: AppColors.dark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
