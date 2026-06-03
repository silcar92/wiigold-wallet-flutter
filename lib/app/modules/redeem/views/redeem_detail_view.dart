import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/data/models/entities/redeems_model.dart';
import 'package:wiigold/app/data/models/responses/easypost_model.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_detail_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class RedeemDetailView extends GetView<RedeemDetailController> {
  const RedeemDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.standard,
      appBar: DynamicAppBar(
        showLogo: true,
        showAutoBackButton: false,
        showActions: true,
        scaffoldKey: scaffoldKey,
      ),
      onRefresh: controller.chargeData,
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 40,
        bottom: 20,
      ),
      body: const RedeemActivePage(),
      bottomNavigationBar: DynamicBottomNavigation(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class RedeemActivePage extends GetView<RedeemDetailController> {
  const RedeemActivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => RichText(
            text: TextSpan(
              style: textTheme.displayLarge,
              children: [
                TextSpan(
                  text: 'redeem.detail_view.title'.tr,
                  style: TextStyle(fontSize: 28),
                ),
                TextSpan(
                  text:
                      "#${controller.r.value?.withdrawal_reference ?? 'redeem.detail_view.loading'.tr}",
                  style: const TextStyle(color: AppColors.main, fontSize: 34),
                ),
              ],
            ),
          ),
        ),
        const DynamicDivider(height: 50),
        Obx(() {
          final redeem = controller.r.value;
          if (redeem == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.main),
            );
          }
          if (redeem.status == RedeemStatus.cancelled ||
              redeem.status == RedeemStatus.rejected) {
            return _FinalStatusView(status: redeem.status);
          }
          final visualSteps = controller.stepperVisualSteps;
          final currentVisualStepIndex = controller
              .calculateCurrentVisualStepIndex();
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visualSteps.length,
            itemBuilder: (context, index) => _RedeemStep(
              controller: controller,
              index: index,
              currentVisualStepIndex: currentVisualStepIndex,
            ),
          );
        }),
        const DynamicDivider(height: 40),
        DynamicButton(
          baseColor: AppColors.transparent,
          borderColor: AppColors.main,
          onPressed: () => Get.offAndToNamed(AppRoutes.REDEEM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back, size: 20, color: AppColors.main),
              const SizedBox(width: 8),
              Text(
                'redeem.detail_view.back_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinalStatusView extends StatelessWidget {
  final RedeemStatus status;

  const _FinalStatusView({required this.status});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final IconData iconData;
    final Color iconColor;
    final String message;
    if (status == RedeemStatus.cancelled) {
      iconData = Icons.cancel_outlined;
      iconColor = AppColors.dark3;
      message = 'redeem.detail_view.status_cancelled_message'.tr;
    } else {
      iconData = Icons.gpp_bad_outlined;
      iconColor = AppColors.failure;
      message = 'redeem.detail_view.status_rejected_message'.tr;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 80, color: iconColor),
          const SizedBox(height: 24),
          Text(
            status.label,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.light,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.dark3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RedeemStep extends StatelessWidget {
  final RedeemDetailController controller;
  final int index;
  final int currentVisualStepIndex;

  const _RedeemStep({
    required this.controller,
    required this.index,
    required this.currentVisualStepIndex,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visualSteps = controller.stepperVisualSteps;
    final visualStep = visualSteps[index];
    final isCompleted = index <= currentVisualStepIndex;
    final subtitle = controller.getSubtitleForStep(
      index,
      currentVisualStepIndex,
    );

    return Obx(() {
      final isCurrent = index == controller.currentStep.value;
      final indicatorColor = isCompleted ? AppColors.main : AppColors.main2;
      final titleColor = isCompleted ? AppColors.main : AppColors.dark2;

      Widget content;
      if (visualStep == RedeemStepVisual.shipped && isCurrent) {
        content = _TrackingDetailsView(controller: controller);
      } else {
        content = controller.buildStepContent(visualStep);
      }

      return InkWell(
        onTap: () => controller.toggleStep(index),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 38.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 60.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visualStep.label,
                        style: textTheme.titleLarge?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: Text(
                            subtitle,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.dark2,
                            ),
                          ),
                        ),
                      if (isCurrent) ...[
                        const DynamicDivider(height: 12),
                        content,
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 30,
              child: Column(
                children: [
                  SizedBox(
                    height: 29,
                    child: index != 0
                        ? Container(width: 2, color: indicatorColor)
                        : null,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isCurrent ? indicatorColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: indicatorColor, width: 2),
                    ),
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            color: isCurrent ? AppColors.light : AppColors.main,
                            size: 18,
                          )
                        : null,
                  ),
                  Expanded(
                    child: index != visualSteps.length - 1
                        ? Container(width: 2, color: indicatorColor)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TrackingDetailsView extends StatelessWidget {
  final RedeemDetailController controller;

  const _TrackingDetailsView({required this.controller});

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));

    DynamicToast.info(
      title: 'redeem.detail_view.copied_toast_title'.tr,
      description: 'redeem.detail_view.copied_toast_description'.trParams({
        'label': label,
      }),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      DynamicToast.error(title: 'redeem.detail_view.link_error_title'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Obx(() {
      if (controller.isFetchingTracker.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: AppColors.main),
          ),
        );
      }
      final tracker = controller.easypostTracker.value;
      if (tracker == null) {
        return InkWell(
          onTap: () => controller.fetchTrackingDetails(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'redeem.detail_view.fetch_data_error'.tr,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.failure),
            ),
          ),
        );
      }
      final isDelivered = tracker.status.toLowerCase() == 'delivered';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDelivered)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'redeem.detail_view.delivered_status'.tr,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const DynamicDivider(height: 16),
          Text(
            'redeem.detail_view.carrier_label'.trParams({
              'carrier': tracker.carrier,
            }),
            style: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
          ),
          const DynamicDivider(height: 8),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  'redeem.detail_view.tracking_label'.trParams({
                    'trackingCode': tracker.trackingCode,
                  }),
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.dark2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18, color: AppColors.dark2),
                onPressed: () => _copyToClipboard(
                  tracker.trackingCode,
                  'redeem.detail_view.tracking_number_label_for_copy'.tr,
                ),
              ),
            ],
          ),
          const DynamicDivider(height: 16),
          Text(
            'redeem.detail_view.shipping_history_label'.tr,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const DynamicDivider(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tracker.trackingDetails.length,
            itemBuilder: (ctx, index) => _TrackingDetailItem(
              detail: tracker.trackingDetails[index],
              isLast: index == tracker.trackingDetails.length - 1,
            ),
          ),
          const DynamicDivider(height: 20),
          if (tracker.publicUrl.isNotEmpty)
            DynamicButton(
              baseColor: AppColors.dark2,
              onPressed: () => _launchURL(tracker.publicUrl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'redeem.detail_view.view_on_carrier_website_button'.tr,

                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.light,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: AppColors.light,
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}

class _TrackingDetailItem extends StatelessWidget {
  final TrackingDetail detail;
  final bool isLast;

  const _TrackingDetailItem({required this.detail, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.main,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 70, color: AppColors.dark2),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.message,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail.datetime.toDateTimeFormat(showTime: true),
                  style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
                ),
                if (detail.location != null &&
                    detail.location.toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      detail.location.toString(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.dark2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
