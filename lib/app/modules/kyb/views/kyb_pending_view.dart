import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/modules/kyb/controllers/kyb_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class KybPendingView extends GetView<KybController> {
  const KybPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: false,
      ),
      isContentCentered: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 24,
        children: [
          const Icon(
            Icons.pending_outlined,
            size: 72,
            color: AppColors.main,
          ),
          Text(
            'Solicitud enviada',
            style: textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            'Tu información está siendo revisada por nuestro equipo de compliance. '
            'Te notificaremos cuando la revisión esté completa.',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            textAlign: TextAlign.center,
          ),
          Text(
            'Tiempo estimado: 1-3 días hábiles.',
            style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
