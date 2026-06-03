import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/data/models/entities/card_model.dart';
import 'package:wiigold/app/modules/card/controllers/card_controller.dart';
import 'package:wiigold/app/modules/card/widgets/card_transaction_list.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/card/widgets/credit_card.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class CardView extends GetView<CardController> {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      appBar: DynamicAppBar(
        showLogo: false,
        showActions: false,
        backbuttomFunction: () async {
          Get.find<HomeController>().chargeData();
          Get.offAllNamed(AppRoutes.HOME);
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      isContentCentered: false,
      onRefresh: controller.chargeData,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [DynamicLoading()],
            ),
          );
        }

        if (controller.hasActiveCard.value) {
          return const CardPage();
        } else {
          return const ActivateCardPage();
        }
      }),
      bottomNavigationBar: DynamicBottomNavigation(),
    );
  }
}

class CardPage extends GetView<CardController> {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(
            () => controller.card.value?.status == CardStatus.BLOCKED
                ? Text(
                    'card.view.blocked_card_label'.tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.failure,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => ActionButton(
                          icon: controller.card.value?.isFrozen ?? false
                              ? Icons.play_arrow
                              : Icons.ac_unit,
                          label: controller.card.value?.isFrozen ?? false
                              ? 'card.view.unfreeze_button'.tr
                              : 'card.view.freeze_button'.tr,
                          onTap: controller.toggleFreezeCard,
                        ),
                      ),
                      ActionButton(
                        icon: Icons.lock,
                        label: 'card.view.block_button'.tr,
                        onTap: controller.blockCard,
                      ),
                    ],
                  ),
          ),
          const DynamicDivider(height: 20),
          Obx(
            () => CreditCard(
              cardNumber: controller.card.value?.cardNumber,
              expiryDate: controller.card.value?.status == CardStatus.BLOCKED
                  ? null
                  : controller.card.value?.expiryDate,
              cvv: controller.card.value?.status == CardStatus.BLOCKED
                  ? null
                  : controller.card.value?.cvv,
            ),
          ),
          const DynamicDivider(height: 40),
          Obx(
            () => controller.card.value?.status == CardStatus.BLOCKED
                ? const SizedBox()
                : DynamicButton(
                    borderColor: AppColors.main,
                    baseColor: AppColors.transparent,
                    onPressed: controller.requestPhysicalCard,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'card.view.request_physical_card_button'.tr,
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.main,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const DynamicDivider(height: 40),
          Text(
            "card.view.recent_movements_title".tr,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const DynamicDivider(height: 10),
          const CardTransactionList(),
        ],
      ),
    );
  }
}

class ActivateCardPage extends GetView<CardController> {
  const ActivateCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_off, size: 80, color: AppColors.light2),
          const DynamicDivider(height: 20),
          Text(
            "card.activate_page.no_card_title".tr,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const DynamicDivider(height: 10),
          Text(
            "card.activate_page.activate_subtitle".tr,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const DynamicDivider(height: 40),
          DynamicButton(
            onPressed: controller.activateVirtualCard,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'card.activate_page.activate_button'.tr,
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.light,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.main, size: 30),
          const DynamicDivider(height: 5),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
