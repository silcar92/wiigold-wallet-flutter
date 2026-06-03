import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/kyb/controllers/kyb_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class KybUboListView extends GetView<KybController> {
  const KybUboListView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: false,
        title: const Text('Beneficiarios finales'),
      ),
      isContentCentered: false,
      body: const _UboListBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            DynamicButton(
              width: double.infinity,
              onPressed: () => Get.toNamed(AppRoutes.KYB_UBO_FORM),
              borderColor: AppColors.main,
              baseColor: Colors.transparent,
              child: Text(
                'Agregar beneficiario',
                style: textTheme.labelLarge?.copyWith(color: AppColors.main),
              ),
            ),
            DynamicButton(
              width: double.infinity,
              onPressed: controller.completeUboStep,
              child: Text(
                'Continuar',
                style: textTheme.labelLarge?.copyWith(color: AppColors.light),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UboListBody extends StatefulWidget {
  const _UboListBody();

  @override
  State<_UboListBody> createState() => _UboListBodyState();
}

class _UboListBodyState extends State<_UboListBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<KybController>().loadUboList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<KybController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text('Beneficiarios finales (UBO)', style: textTheme.displayLarge),
        Text(
          'Agrega a las personas con control o propiedad del 25% o más de la empresa.',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
        ),
        Obx(() {
          if (controller.uboList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Ningún beneficiario agregado aún.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
                ),
              ),
            );
          }
          return Column(
            spacing: 12,
            children: controller.uboList
                .map((ubo) => _UboCard(ubo: ubo))
                .toList(),
          );
        }),
      ],
    );
  }
}

class _UboCard extends StatelessWidget {
  final Map<String, dynamic> ubo;

  const _UboCard({required this.ubo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<KybController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  ubo['full_name'] ?? '-',
                  style: textTheme.titleMedium,
                ),
                Text(
                  'Participación: ${ubo['ownership_percentage'] ?? '-'}%',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
                ),
                if (ubo['nationality'] is Map)
                  Text(
                    (ubo['nationality'] as Map)['name'] ?? '',
                    style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.failure),
            onPressed: () => controller.deleteUbo(ubo['id'] as int),
          ),
        ],
      ),
    );
  }
}
