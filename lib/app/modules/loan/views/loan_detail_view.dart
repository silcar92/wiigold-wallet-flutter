import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';

//? CONTROLLERS

//? HANDLERS

//? THEME & IMAGES

//? WIDGETS
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_detail_controller.dart';
import 'package:wiigold/app/modules/loan/widgets/payment_list.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class LoanDetailView extends GetView<LoanDetailController> {
  const LoanDetailView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        Get.offAllNamed(AppRoutes.LOAN);
      },
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: true,
        backbuttomFunction: () {
          Get.offAllNamed(AppRoutes.LOAN);
        },
      ),
      onReady: controller.handleParams,
      onRefresh: controller.chargeData,
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 40,
        bottom: 20,
      ),
      body: LoanActivePage(),
      bottomNavigationBar: DynamicBottomNavigation(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class LoanActivePage extends GetView<LoanDetailController> {
  const LoanActivePage({super.key});

  @override
  //? ROOT PAGE
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget _buildDetailRow(String label, String info) {
      return RichText(
        text: TextSpan(
          style: textTheme.headlineMedium?.copyWith(
            height: 1.25,
            color: AppColors.dark2,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(text: '${label}\n'),
            TextSpan(
              text: info,
              style: TextStyle(
                color: AppColors.main,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    Widget LoanInfo() {
      return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => _buildDetailRow(
              'loan.detail_view.loan_amount_label'.tr,
              controller.loanAmount.value,
            ),
          ),
          DynamicDivider(height: 20),
          Obx(
            () => _buildDetailRow(
              'loan.detail_view.interest_rate_label'.tr,
              controller.interestRate.value,
            ),
          ),
          DynamicDivider(height: 20),
          Obx(
            () => _buildDetailRow(
              'loan.detail_view.accrued_interest_label'.tr,
              controller.accruedInterest.value,
            ),
          ),
          DynamicDivider(height: 20),
          Obx(
            () => _buildDetailRow(
              'loan.detail_view.total_paid_label'.tr,
              controller.paidAmount.value,
            ),
          ),
          DynamicDivider(height: 20),
          Obx(
            () => _buildDetailRow(
              'loan.detail_view.current_debt_label'.tr,
              controller.remainingAmountLabel.value,
            ),
          ),
          DynamicDivider(height: 20),
          Obx(
            () => _buildDetailRow(
              'loan.detail_view.due_date_label'.tr,
              controller.dueDate.value,
            ),
          ),
          DynamicDivider(height: 20),
          Obx(
            () => _buildDetailRow(
              'loan.detail_view.collateral_label'.tr,
              controller.collateral.value,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => RichText(
            text: TextSpan(
              style: textTheme.displayLarge,
              children: [
                TextSpan(
                  text: 'loan.detail_view.title_part1'.tr,
                  style: TextStyle(fontSize: 28),
                ),
                TextSpan(
                  text: "#${controller.loanReference.value}",
                  style: TextStyle(color: AppColors.main, fontSize: 34),
                ),
              ],
            ),
          ),
        ),
        DynamicDivider(height: 50),

        LoanInfo(),

        DynamicDivider(height: 50),

        Obx(() => PaymentList(payments: controller.paymentList.value)),

        DynamicDivider(height: 50),

        Obx(() {
          if (controller.remainingAmount.value == 0.0) {
            return SizedBox.shrink();
          }

          return DynamicButton(
            semanticSettings: ButtonSemantics(identifier: 'makePayment'),
            disabledColor: AppColors.dark2,
            baseColor: AppColors.main,
            isGradient: true,
            onPressed: () => {
              Get.toNamed(
                AppRoutes.LOAN_PAYMENT,
                parameters: {
                  "data": jsonEncode({
                    "loan_reference": controller.loanReference.value,
                    "amount": controller.remainingAmount.value,
                  }),
                },
              ),
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'loan.detail_view.make_payment_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
              ],
            ),
          );
        }),

        DynamicDivider(height: 10),
        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'backButton'),
          baseColor: AppColors.transparent,
          borderColor: AppColors.main,
          onPressed: () => {Get.toNamed(AppRoutes.LOAN)},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Icon(Icons.arrow_back, size: 20, color: AppColors.main),
              Text(
                'loan.detail_view.back_button'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.main),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
