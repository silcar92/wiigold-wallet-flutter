import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

//? GetX
import 'package:get/get.dart';

//? WIDGETS
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/data/models/constants/kyc_limits.dart';
import 'package:wiigold/app/modules/auth/controllers/auth_controller.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/modules/profile/widgets/kyc_limits_card.dart';
import 'package:wiigold/theme/Colors.dart';

class KycView extends GetView<ProfileController> {
  const KycView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(() {
      final cs = controller.currentUser.value?.compliance_status ?? '';
      final isBlockedState = cs == '330' || cs == '350';

      return DynamicAppScaffold(
        isLoading: controller.isLoading,
        showLoader: controller.showLoader,
        scaffoldKey: scaffoldKey,
        appBar: DynamicAppBar(
          scaffoldKey: scaffoldKey,
          showLogo: true,
          showActions: !isBlockedState,
          showAutoBackButton: !isBlockedState,
        ),
        isContentCentered: true,
        body: KycPage(),
        drawer: isBlockedState ? null : DrawerView(scaffoldKey: scaffoldKey),
      );
    });
  }
}

class KycPage extends GetView<ProfileController> {
  const KycPage({super.key});

  static const String _supportEmail = 'soporte@hauvtrading.com';

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) return const SizedBox.shrink();

      final cs = user.compliance_status ?? '';

      if (cs == '330') return _buildReviewPage(textTheme);
      if (cs == '350') return _buildRejectedPage(textTheme);
      if (KycLimits.isApproved(cs)) return _buildApprovedPage(textTheme, cs);
      return _buildVerifyPage(textTheme);
    });
  }

  // E2 — PENDING_MANUAL_REVIEW (330)
  Widget _buildReviewPage(TextTheme textTheme) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Icon(Icons.hourglass_top_rounded, size: 64, color: AppColors.dark2),
        ),
        DynamicDivider(height: 8),
        Text(
          'Tu cuenta está en revisión',
          style: textTheme.displayLarge?.copyWith(height: 1.1),
        ),
        Text(
          'Tu cuenta requiere una validación adicional. Te notificaremos cuando finalice la revisión o si necesitamos información complementaria.',
          style: textTheme.titleSmall?.copyWith(overflow: TextOverflow.visible),
        ),
        DynamicDivider(height: 8),
        RichText(
          text: TextSpan(
            style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
            children: [
              const TextSpan(text: 'Si tienes dudas puedes escribirnos a '),
              TextSpan(
                text: _supportEmail,
                style: TextStyle(
                  color: AppColors.main,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse('mailto:$_supportEmail')),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // E3 — REJECTED (350)
  Widget _buildRejectedPage(TextTheme textTheme) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Icon(Icons.cancel_outlined, size: 64, color: AppColors.failure),
        ),
        DynamicDivider(height: 8),
        Text(
          'No pudimos verificar tu cuenta',
          style: textTheme.displayLarge?.copyWith(height: 1.1),
        ),
        Text(
          'No fue posible completar la verificación conforme a nuestras políticas internas y obligaciones aplicables.',
          style: textTheme.titleSmall?.copyWith(overflow: TextOverflow.visible),
        ),
        DynamicDivider(height: 8),
        RichText(
          text: TextSpan(
            style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
            children: [
              const TextSpan(text: 'Si consideras que se trata de un error, puedes contactarnos en '),
              TextSpan(
                text: _supportEmail,
                style: TextStyle(
                  color: AppColors.main,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse('mailto:$_supportEmail')),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // E1 — KYC aprobado (340 / KYC_APPROVED_STANDARD / KYC_APPROVED_ENHANCED_LIMITED / EDD_APPROVED)
  Widget _buildApprovedPage(TextTheme textTheme, String cs) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Icon(
            Icons.verified_outlined,
            size: 64,
            color: AppColors.success,
          ),
        ),
        DynamicDivider(height: 8),
        Text(
          'Cuenta verificada',
          style: textTheme.displayLarge?.copyWith(height: 1.1),
        ),
        Text(
          'Tu identidad ha sido validada. A continuación puedes ver los límites operativos de tu nivel de verificación actual.',
          style: textTheme.titleSmall?.copyWith(overflow: TextOverflow.visible),
        ),
        DynamicDivider(height: 4),
        KycLimitsCard(complianceStatus: cs),
      ],
    );
  }

  // Default — estados 300, 310, 320 (flujo de verificación normal)
  Widget _buildVerifyPage(TextTheme textTheme) {
    return Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'profile.kyc_view.title'.tr,
              style: textTheme.displayLarge?.copyWith(height: 1.1),
            ),
          ],
        ),
        DynamicDivider(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                'profile.kyc_view.subtitle'.tr,
                style: textTheme.titleSmall?.copyWith(
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),
        DynamicDivider(height: 10),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                children: [
                  TextSpan(text: 'profile.kyc_view.status_label'.tr),
                  TextSpan(
                    text: controller.getStatus(
                      controller.currentUser.value?.compliance_status ?? '',
                    ),
                    style: TextStyle(color: AppColors.dark2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (controller.shouldShowVerificationButton)
              DynamicButton(
                disabledColor: AppColors.dark2,
                width: double.infinity,
                onPressed: () => Get.find<AuthController>().kycVerification(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'profile.kyc_view.verify_button'.tr,
                      style: textTheme.titleLarge?.copyWith(color: AppColors.dark),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20, color: AppColors.dark),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
