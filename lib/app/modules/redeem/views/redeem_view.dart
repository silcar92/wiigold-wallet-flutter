import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/data/models/entities/redeems_model.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_controller.dart';
import 'package:wiigold/app/modules/redeem/widgets/redeem_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class RedeemView extends GetView<RedeemController> {
  const RedeemView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return DynamicAppScaffold(
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () async {
        Get.find<HomeController>().chargeData();

        Get.offAllNamed(AppRoutes.HOME);
      },
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: true,
        showAutoBackButton: true,
        showActions: true,
        backbuttomFunction: () async {
          Get.find<HomeController>().chargeData();

          Get.offAllNamed(AppRoutes.HOME);
        },
      ),
      isContentCentered: false,
      onRefresh: controller.chargeData,
      body: RedeemPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class RedeemPage extends GetView<RedeemController> {
  const RedeemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [DynamicLoading()],
          ),
        );
      }

      if (controller.redeems.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.main,
                size: 80,
              ),
              const DynamicDivider(height: 20),
              Text(
                'redeem.view.no_active_requests_title'.tr,
                style: textTheme.displaySmall?.copyWith(color: AppColors.main),
              ),
              const DynamicDivider(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'redeem.view.no_active_requests_description'.tr,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
                ),
              ),
              const DynamicDivider(height: 80),
              DynamicButton(
                baseColor: AppColors.main,
                onPressed: () => Get.toNamed(AppRoutes.REDEEM_SELECTOR),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'redeem.view.request_physical_gold_button'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.light,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return const RedeemList();
    });
  }
}

class RedeemList extends GetView<RedeemController> {
  const RedeemList({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget buildDetailRow({required String label, required String value}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.dark2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.main,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    Color getStatusColor(RedeemStatus status) {
      switch (status) {
        case RedeemStatus.cancelled:
        case RedeemStatus.rejected:
          return AppColors.failure;
        case RedeemStatus.completed:
        case RedeemStatus.delivered:
          return Colors.green;
        case RedeemStatus.paymentVerified:
        case RedeemStatus.shipped:
          return AppColors.main2;
        default:
          return AppColors.dark2;
      }
    }

    ({String label, String? date}) getRelevantDateInfo(Redeem redeem) {
      switch (redeem.status) {
        case RedeemStatus.completed:
        case RedeemStatus.delivered:
          return (
            label: 'redeem.view.date_completed'.tr,
            date: redeem.completedDate,
          );
        case RedeemStatus.shipped:
          return (
            label: 'redeem.view.date_shipped'.tr,
            date: redeem.shippedDate,
          );
        case RedeemStatus.accepted:
        case RedeemStatus.paymentPending:
        case RedeemStatus.paymentVerified:
        case RedeemStatus.processing:
        case RedeemStatus.processingComplete:
          return (
            label: 'redeem.view.date_accepted'.tr,
            date: redeem.acceptedDate,
          );
        case RedeemStatus.quoted:
          return (label: 'redeem.view.date_quoted'.tr, date: redeem.quoteDate);
        case RedeemStatus.pendingQuote:
        default:
          return (
            label: 'redeem.view.date_requested'.tr,
            date: redeem.createdAt,
          );
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicButton(
            baseColor: AppColors.main,
            isGradient: true,
            onPressed: () => Get.toNamed(AppRoutes.REDEEM_SELECTOR),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'redeem.view.new_request_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
              ],
            ),
          ),
          const DynamicDivider(height: 30),
          Text(
            'redeem.view.active_requests_title'.tr,
            style: textTheme.displayMedium?.copyWith(
              color: AppColors.dark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const DynamicDivider(height: 30),

          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: controller.redeems.length,
              separatorBuilder: (_, __) => const DynamicDivider(height: 20),
              itemBuilder: (context, index) {
                final redeem = controller.redeems[index];
                final fullAddress =
                    '${redeem.country.name}, ${redeem.region.name}, ${redeem.shippingAddress}.';

                final relevantDateInfo = getRelevantDateInfo(redeem);

                return GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.REDEEM_DETAIL,
                    parameters: {
                      "data": jsonEncode({"redeem": redeem.toJson()}),
                    },
                  ),
                  child: Card(
                    elevation: 0,
                    color: AppColors.light,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'redeem.view.request_card_title'.trParams({
                                    'reference':
                                        redeem.withdrawal_reference ?? '',
                                  }),
                                  style: textTheme.titleSmall?.copyWith(
                                    color: AppColors.dark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(redeem.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    redeem.status.label,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.light,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const DynamicDivider(height: 20),
                          buildDetailRow(
                            label: 'redeem.view.asset_requested_label'.tr,
                            value:
                                '${redeem.quantityRequested.toHauvNumericString()} ${redeem.asset.name}',
                          ),
                          const DynamicDivider(height: 10),
                          buildDetailRow(
                            label: 'redeem.view.shipping_address_label'.tr,
                            value: fullAddress,
                          ),

                          if (relevantDateInfo.date != null) ...[
                            const DynamicDivider(height: 10),
                            buildDetailRow(
                              label: relevantDateInfo.label,
                              value: relevantDateInfo.date ?? '',
                            ),
                          ],

                          if (redeem.quoteAmount != null &&
                              redeem.quoteCurrency != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: buildDetailRow(
                                label: 'redeem.view.shipping_cost_label'.tr,
                                value:
                                    '${redeem.quoteAmount!.toHauvNumericString(decimals: 2)} ${redeem.quoteCurrency?.code ?? ''}',
                              ),
                            ),
                          if (redeem.trackingNumber != null &&
                              redeem.trackingNumber!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: buildDetailRow(
                                label: 'redeem.view.tracking_number_label'.tr,
                                value: redeem.trackingNumber!,
                              ),
                            ),
                          if (redeem.carrierCompany != null &&
                              redeem.carrierCompany!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: buildDetailRow(
                                label: 'redeem.view.carrier_label'.tr,
                                value: redeem.carrierCompany!,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
