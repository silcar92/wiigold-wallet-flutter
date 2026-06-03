import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/kyb/controllers/kyb_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class KybStatusView extends GetView<KybController> {
  const KybStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: false,
        title: const Text('Estado KYB'),
      ),
      isContentCentered: false,
      body: const _StatusBody(),
    );
  }
}

class _StatusBody extends StatefulWidget {
  const _StatusBody();

  @override
  State<_StatusBody> createState() => _StatusBodyState();
}

class _StatusBodyState extends State<_StatusBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<KybController>().loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<KybController>();

    return Obx(() {
      final status = controller.kybStatus.value;
      final reason = controller.declineReason.value;

      final (icon, iconColor, title, subtitle) = switch (status) {
        'approved' => (
            Icons.check_circle_outline,
            AppColors.main,
            'Verificación aprobada',
            'Tu empresa ha sido verificada exitosamente.',
          ),
        'declined' => (
            Icons.cancel_outlined,
            AppColors.failure,
            'Verificación rechazada',
            reason.isNotEmpty ? reason : 'Tu solicitud fue rechazada.',
          ),
        'frozen' => (
            Icons.lock_outlined,
            AppColors.dark2,
            'Cuenta congelada',
            'Contacta a soporte para más información.',
          ),
        _ => (
            Icons.pending_outlined,
            AppColors.main,
            'En revisión',
            'Tu solicitud está siendo revisada. Te notificaremos cuando esté lista.',
          ),
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 24,
        children: [
          const SizedBox(height: 32),
          Icon(icon, size: 72, color: iconColor),
          Text(title, style: textTheme.displayLarge, textAlign: TextAlign.center),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            textAlign: TextAlign.center,
          ),
          if (status == 'declined')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DynamicButton(
                width: double.infinity,
                onPressed: controller.resubmit,
                child: Text(
                  'Corregir y reenviar',
                  style: textTheme.labelLarge?.copyWith(color: AppColors.light),
                ),
              ),
            ),
        ],
      );
    });
  }
}
