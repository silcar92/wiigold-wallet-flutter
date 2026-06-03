import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/core/services/splash/controllers/splash_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      backButtonBehavior: BackButtonBehavior.closeApp,
      backgroundColor: AppColors.main,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [DynamicLoader()],
      ),
    );
  }
}
