import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/register/controllers/register_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class PersonTypeSelectorView extends GetView<RegisterController> {
  const PersonTypeSelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () => Get.offAllNamed(AppRoutes.LOGIN),
      appBar: DynamicAppBar(
        showAutoBackButton: true,
        backbuttomFunction: () => Get.offAllNamed(AppRoutes.LOGIN),
      ),
      isContentCentered: false,
      body: _PersonTypeSelectorPage(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Obx(() => DynamicButton(
          width: double.infinity,
          isDisabled: !controller.hasMadeSelection.value,
          onPressed: controller.continueFromTypeSelector,
          child: Center(
            child: Text(
              'register.person_type.continue_button'.tr,
              style: textTheme.labelLarge?.copyWith(color: AppColors.light),
            ),
          ),
        )),
      ),
    );
  }
}

class _PersonTypeSelectorPage extends GetView<RegisterController> {
  const _PersonTypeSelectorPage();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicDivider(height: 16),

          Text(
            'register.person_type.title'.tr,
            style: textTheme.displayLarge?.copyWith(height: 1.1),
          ),

          const SizedBox(height: 8),

          Text(
            'register.person_type.subtitle'.tr,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
          ),

          const SizedBox(height: 40),

          _PersonTypeCard(
            type: 'natural',
            icon: Icons.person_outline,
            titleKey: 'register.person_type.natural_title',
            descriptionKey: 'register.person_type.natural_description',
          ),

          const SizedBox(height: 16),

          _PersonTypeCard(
            type: 'juridica',
            icon: Icons.business_outlined,
            titleKey: 'register.person_type.juridica_title',
            descriptionKey: 'register.person_type.juridica_description',
          ),
        ],
      ),
    );
  }
}

class _PersonTypeCard extends GetView<RegisterController> {
  final String type;
  final IconData icon;
  final String titleKey;
  final String descriptionKey;

  const _PersonTypeCard({
    required this.type,
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => controller.selectPersonType(type),
      child: Obx(() {
        final selected = controller.selectedPersonType.value == type;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: selected ? AppColors.main.withValues(alpha: 0.08) : AppColors.appBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.main : AppColors.dark3,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.main : AppColors.dark3.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: selected ? AppColors.light : AppColors.dark2,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleKey.tr,
                      style: textTheme.titleMedium?.copyWith(
                        color: selected ? AppColors.main : AppColors.dark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descriptionKey.tr,
                      style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
                    ),
                  ],
                ),
              ),

              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? AppColors.main : AppColors.dark3,
              ),
            ],
          ),
        );
      }),
    );
  }
}
