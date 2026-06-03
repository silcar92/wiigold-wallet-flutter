import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_otp.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/security/controllers/security_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class Setup2FAView extends GetView<SecurityController> {
  const Setup2FAView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showAutoBackButton: true,
        showLogo: false,
        backbuttomFunction: () => Get.back(),
      ),
      isContentCentered: false,
      body: Setup2FAPage(),
    );
  }
}

class Setup2FAPage extends GetView<SecurityController> {
  const Setup2FAPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          'security.setup_2fa.title'.tr,
          style: textTheme.displayLarge,
        ),
        Text(
          'security.setup_2fa.subtitle'.tr,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
        ),

        // QR code or status
        Obx(() {
          if (controller.is2FAEnabled.value) {
            return _TotpEnabledSection();
          }
          if (controller.totpUri.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return _TotpSetupSection();
        }),
      ],
    );
  }
}

class _TotpSetupSection extends GetView<SecurityController> {
  const _TotpSetupSection();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        // Open in app button
        DynamicButton(
          width: double.infinity,
          onPressed: controller.openInAuthenticatorApp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.open_in_new, color: AppColors.light, size: 18),
              const SizedBox(width: 8),
              Text(
                'security.setup_2fa.open_in_app'.tr,
                style: textTheme.labelLarge?.copyWith(color: AppColors.light),
              ),
            ],
          ),
        ),

        DynamicDivider(),

        // Secret key
        Text(
          'security.setup_2fa.manual_entry'.tr,
          style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
        ),
        Obx(() => GestureDetector(
          onTap: controller.toggleSecretVisibility,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.appAltBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.dark3),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.secretVisible.value
                        ? controller.totpSecret.value
                        : '• • • • • • • • • • • •',
                    style: textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: controller.secretVisible.value ? 2 : 4,
                    ),
                  ),
                ),
                Icon(
                  controller.secretVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.dark2,
                  size: 20,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: controller.copySecret,
                  child: const Icon(Icons.copy, color: AppColors.dark2, size: 20),
                ),
              ],
            ),
          ),
        )),

        DynamicDivider(),

        // Code input
        Text(
          'security.setup_2fa.enter_code'.tr,
          style: textTheme.bodyMedium,
        ),
        Center(
          child: DynamicOtp(controller: controller.totpCodeController),
        ),

        // Activate button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: DynamicButton(
            width: double.infinity,
            onPressed: controller.activateTOTP,
            child: Center(
              child: Text(
                'security.setup_2fa.activate_button'.tr,
                style: textTheme.labelLarge?.copyWith(color: AppColors.light),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TotpEnabledSection extends GetView<SecurityController> {
  const _TotpEnabledSection();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user, color: AppColors.success, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'security.setup_2fa.enabled_title'.tr,
                    style: textTheme.titleMedium?.copyWith(color: AppColors.success),
                  ),
                  Text(
                    'security.setup_2fa.enabled_subtitle'.tr,
                    style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
