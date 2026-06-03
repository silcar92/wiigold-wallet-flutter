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
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';

import 'package:wiigold/app/modules/loan/controllers/loan_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class LoanView extends GetView<LoanController> {
  const LoanView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.toHome,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: true,
        showAutoBackButton: true,
        showActions: true,
        backbuttomFunction: () async {
          Get.find<HomeController>().chargeData();

          Get.toNamed(AppRoutes.HOME);
        },
      ),
      isContentCentered: false,
      onRefresh: controller.chargeData,
      body: LoanPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class LoanPage extends GetView<LoanController> {
  const LoanPage({super.key});

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

      if (controller.loans.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.main,
                size: 80,
              ),
              const DynamicDivider(height: 20),
              Text(
                'loan.view.no_active_loans_title'.tr,
                style: textTheme.displaySmall?.copyWith(color: AppColors.main),
              ),
              const DynamicDivider(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'loan.view.no_active_loans_description'.tr,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
                ),
              ),
              const DynamicDivider(height: 80),
              DynamicButton(
                isGradient: true,
                baseColor: AppColors.main,
                onPressed: () => {Get.toNamed(AppRoutes.LOAN_SELECTOR)},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Text(
                      'loan.view.request_loan_button'.tr,
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

      return LoanList();
    });
  }
}

class LoanList extends GetView<LoanController> {
  const LoanList({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget _buildDetailRow({
      required TextTheme textTheme,
      required String label,
      required String value,
    }) {
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
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.main,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        DynamicButton(
          baseColor: AppColors.main,
          isGradient: true,
          onPressed: () => {Get.toNamed(AppRoutes.LOAN_SELECTOR)},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'loan.view.new_loan_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
            ],
          ),
        ),

        const DynamicDivider(height: 30),

        Text(
          'loan.view.active_loans_title'.tr,
          style: textTheme.displayMedium?.copyWith(
            color: AppColors.dark,
            fontWeight: FontWeight.w500,
          ),
        ),

        DynamicDivider(height: 30),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: controller.loans.length,
          itemBuilder: (context, index) {
            final l = controller.loans[index];
            final c = l['collateral'];

            return GestureDetector(
              onTap: () => controller.showDetail(l["loan_reference"]),
              child: Card(
                elevation: 0,
                color: AppColors.light,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'loan.view.loan_card_title'.trParams({
                              'reference': l['loan_reference'],
                            }),
                            style: textTheme.titleSmall?.copyWith(
                              color: AppColors.dark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: l['is_overdue']
                                  ? AppColors.failure
                                  : AppColors.main2,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l['status_display'],
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.light,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const DynamicDivider(height: 15),

                      _buildDetailRow(
                        textTheme: textTheme,
                        label: 'loan.view.requested_amount_label'.tr,
                        value:
                            '${l['loan_amount_usd'].toString().toHauvNumericString(decimals: 2)} USD',
                      ),

                      const DynamicDivider(height: 8),

                      _buildDetailRow(
                        textTheme: textTheme,
                        label: 'loan.view.due_date_label'.tr,
                        value: l['due_date'] != null
                            ? DateTime.parse(l['due_date']).toDateTimeFormat(
                                formatAsHeader: true,
                                showTime: true,
                                showDate: true,
                              )
                            : '',
                      ),

                      const DynamicDivider(height: 8),

                      _buildDetailRow(
                        textTheme: textTheme,
                        label: 'loan.view.locked_collateral_label'.tr,
                        value:
                            '${c['amount_locked'].toString().toHauvNumericString()} ${c['asset_name']}',
                      ),

                      const DynamicDivider(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'loan.view.payment_progress_label'.tr,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.dark2,
                            ),
                          ),

                          Text(
                            '${(l['payment_progress'])}%',
                            style: textTheme.titleSmall?.copyWith(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const DynamicDivider(height: 8),

                      LinearProgressIndicator(
                        value: l['payment_progress_aux'],
                        backgroundColor: AppColors.dark3,
                        color: AppColors.main,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      const DynamicDivider(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'loan.view.remaining_balance_label'.tr,
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.dark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${l['remaining_balance'].toString().toHauvNumericString(decimals: 2)} USD',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
