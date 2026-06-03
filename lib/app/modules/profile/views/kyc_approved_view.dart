import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/modules/profile/widgets/kyc_limits_card.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class KycApprovedView extends GetView<ProfileController> {
  const KycApprovedView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showLogo: true,
        showAutoBackButton: false,
        showActions: false,
      ),
      isContentCentered: true,
      body: const _ApprovedBody(),
    );
  }
}

class _ApprovedBody extends GetView<ProfileController> {
  const _ApprovedBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final cs = controller.currentUser.value?.compliance_status;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Center(
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 72,
              color: AppColors.success,
            ),
          ),
          DynamicDivider(height: 8),
          Text(
            '¡Tu cuenta ha sido verificada!',
            style: textTheme.displayLarge?.copyWith(height: 1.1),
          ),
          Text(
            'Ya puedes operar dentro de los límites de tu nivel de verificación.',
            style: textTheme.titleSmall?.copyWith(
              overflow: TextOverflow.visible,
              color: AppColors.dark2,
            ),
          ),
          DynamicDivider(height: 4),
          KycLimitsCard(complianceStatus: cs),
          DynamicDivider(height: 8),
          DynamicButton(
            width: double.infinity,
            onPressed: () => Get.offAllNamed(AppRoutes.HOME),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ir al inicio',
                  style: textTheme.titleLarge?.copyWith(color: AppColors.dark),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20, color: AppColors.dark),
              ],
            ),
          ),
        ],
      );
    });
  }
}
