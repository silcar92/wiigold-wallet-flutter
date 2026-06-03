import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? COLORS & IMAGES
import 'package:flutter_svg/svg.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/core/services/transaction_detail/controllers/transaction_detail_controller.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

class TransactionDetailView extends GetView<TransactionDetailController> {
  const TransactionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.toHome,
      appBar: DynamicAppBar(
        showLogo: true,
        showActions: false,
        showAutoBackButton: false,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      body: TransactionDetailPage(),
    );
  }
}

class TransactionDetailPage extends GetView<TransactionDetailController> {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (controller.transaction == null) {
      return Text('screens.transaction_detail.null_transaction'.tr);
    }

    Widget getTransactionInfo() {
      return Flex(
        direction: Axis.vertical,
        children: [
          Divider(height: 1, color: AppColors.dark2),
          DynamicDivider(height: 5),
          Text(
            '${'screens.transaction_detail.transaction_id'.tr}${controller.transaction!.transactionId}',
            style: textTheme.bodySmall?.copyWith(color: AppColors.dark),
            textAlign: TextAlign.center,
          ),

          Text(
            "${controller.transaction!.date}, ${controller.transaction!.time}",
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.dark2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        DynamicDivider(height: 40),

        controller.getTransactionTitle(),

        DynamicDivider(height: 20),

        controller.getTransactionCore(),

        DynamicDivider(height: 20),

        getTransactionInfo(),

        DynamicDivider(height: 50),

        if (controller.viewMode == 'SEND') ...[
          DynamicButton(
            baseColor: Colors.transparent,
            borderColor: AppColors.main,
            isGradient: false,
            onPressed: () => controller.copyTransactionId(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.copy, size: 20, color: AppColors.main),
                SizedBox(width: 8),
                Text(
                  'screens.transaction_detail.copy_transaction_id'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.main),
                ),
              ],
            ),
          ),

          DynamicDivider(height: 5),
        ],

        DynamicButton(
          onPressed: () async {
            Get.find<HomeController>().chargeData();

            Get.offAllNamed(AppRoutes.HOME);
          },
          baseColor: AppColors.main,
          isGradient: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'screens.transaction_detail.go_to_home'.tr,
                style: textTheme.titleLarge?.copyWith(color: AppColors.light),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 75),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String text;
  final String? icon;
  final TextStyle? titleStyle;
  final TextStyle? textStyle;

  const InfoRow({
    Key? key,
    required this.title,
    required this.text,
    this.icon,
    this.titleStyle,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: theme.textTheme.bodySmall?.copyWith(fontSize: 16)),
        if (icon != null) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: SvgPicture.asset(icon!, fit: BoxFit.contain),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}
