import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_convert_rate.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/transaction_detail/widgets/transaction_status_badge.dart';
import 'package:wiigold/app/data/models/entities/transactions_model.dart';
import 'package:wiigold/theme/Colors.dart';

class TransactionDetailController extends GetxController with LoadingMixin {
  TextTheme textTheme = Theme.of(Get.context!).textTheme;
  Transaction? transaction;
  String viewMode = '';

  dynamic data;
  String? fromValue;
  String? toValue;
  Widget? extra;

  late RxString appbarTitle =
      'screens.transaction_detail.controller.default_appbar_title'.tr.obs;

  @override
  void onInit() async {
    super.onInit();
    _handleInitialParams();
  }

  void _handleInitialParams() {
    final params = Get.parameters;
    viewMode = params['viewMode'] ?? 'NORMAL';

    if (params['appbarTitle'] != null) {
      appbarTitle.value = params['appbarTitle']!;
    }

    if (params['transaction'] != null) {
      try {
        transaction = Transaction.fromJson(jsonDecode(params['transaction']!));
      } catch (e) {
        print("e: ${e.toString()}");
      }
    }

    if (params['data'] != null) {
      try {
        data = json.decode(params['data']!);
      } catch (e) {
        print("Error parsing data JSON: $e");
        data = null;
      }
    }

    if (params['transactionExtra'] != null) {
      try {
        final extraData = json.decode(params['transactionExtra']!);

        if (extraData != false) {
          fromValue = extraData['fromAmout'] as String?;
          toValue = extraData['toAmout'] as String?;
        }
      } catch (e) {
        print("Error parsing transactionExtra JSON: $e");
      }
    }

    if (params['useCustomExtra'] == 'true' && params['customExtra'] != null) {
      try {
        final customExtraData = json.decode(params['customExtra']!);
        switch (customExtraData['type']) {
          case 'rate':
            extra = DynamicConverRate(label: '${customExtraData['rate']}');
            break;
          case 'commission':
            extra = Align(
              alignment: Alignment.centerRight,
              child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  style: textTheme.titleSmall,
                  children: [
                    TextSpan(
                      text:
                          'screens.transaction_detail.controller.commission_label'
                              .tr,
                    ),
                    TextSpan(
                      text: customExtraData['commission'],
                      style: TextStyle(
                        color: AppColors.main2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
            break;
        }
      } catch (e) {
        print("Error parsing customExtra JSON: $e");
      }
    }

    update();
  }

  Widget getTransactionTitle() {
    if (transaction == null) {
      return Text(
        'screens.transaction_detail.controller.loading_details'.tr,
        style: textTheme.headlineMedium,
      );
    }

    Text getTransactionLabel() {
      final TextStyle? theme = textTheme.headlineMedium;
      final String status = transaction?.status ?? '';

      String statusText;
      Color statusColor = AppColors.light;

      switch (status.toLowerCase()) {
        case 'completed':
        case 'confirmed':
        case 'success':
          statusText =
              'screens.transaction_detail.controller.status_completed'.tr;
          statusColor = AppColors.success;
          break;
        case 'pending_execution':
        case 'pending':
          statusText =
              'screens.transaction_detail.controller.status_pending'.tr;
          statusColor = AppColors.accent;
          break;
        case 'funds_held_review':
          statusText = 'screens.transaction_detail.controller.status_under_review'.tr;
          statusColor = Colors.orange;
          break;
        case 'failed':
        case 'rejected':
        case 'error':
          statusText = 'screens.transaction_detail.controller.status_failed'.tr;
          statusColor = AppColors.failure;
          break;
        case 'cancelled':
          statusText =
              'screens.transaction_detail.controller.status_cancelled'.tr;
          statusColor = AppColors.failure;
          break;
        default:
          statusText = status.isNotEmpty
              ? status[0].toUpperCase() + status.substring(1)
              : 'n/a'.tr;
          break;
      }

      return Text(statusText, style: theme?.copyWith(color: statusColor));
    }

    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTransactionLabel(),
        const DynamicDivider(height: 10),
        Text(
          'screens.transaction_detail.controller.movement_details_title'.tr,
          style: textTheme.displayLarge?.copyWith(height: 1),
        ),
        const DynamicDivider(height: 20),
        TransactionStatusBadge(status: transaction!.status),
      ],
    );
  }

  Widget getTransactionCore() {
    if (transaction == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Row getTransactionLineDetail(String label, String value) {
      TextStyle? labelStyle = textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.dark,
      );

      TextStyle? valueStyle = textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
      );

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Flexible(
            child: Text(value, style: valueStyle, textAlign: TextAlign.end),
          ),
        ],
      );
    }

    List<Widget> widgets = [];

    if (viewMode == 'SEND') {
      widgets.addAll([
        const DynamicDivider(height: 20),
        Text(
          transaction!.amount.toHauvNumericString(),
          style: textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.main,
            height: 1,
          ),
        ),
        Text(
          transaction?.details['currency']['name'] ?? '',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.main,
          ),
        ),
        const DynamicDivider(height: 40),
        Text(
          'screens.transaction_detail.controller.you_sent_to'.tr,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(data['targetName'] ?? '', style: textTheme.displaySmall),
        const DynamicDivider(height: 10),
        Text(
          'screens.transaction_detail.controller.to_the_wallet'.tr,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.dark2,
          ),
        ),
        Text(
          data['targetAccount'] ?? '',
          style: textTheme.bodySmall?.copyWith(
            height: 1,
            color: AppColors.dark2,
          ),
        ),
        const DynamicDivider(height: 20),
      ]);
    } else if (viewMode == "RECEIVER") {
      widgets.addAll([
        const DynamicDivider(height: 20),
        Text(
          transaction!.amount.toHauvNumericString(),
          style: textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.main,
            height: 1,
          ),
        ),
        Text(
          transaction?.details['currency']['name'] ?? '',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.main,
          ),
        ),
        const DynamicDivider(height: 40),
        Text(
          'screens.transaction_detail.controller.you_received_from'.tr,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(data['targetName'] ?? '', style: textTheme.displaySmall),
        const DynamicDivider(height: 10),
        const DynamicDivider(height: 20),
      ]);
    } else if (viewMode == 'EXCHANGE') {
      widgets.addAll([const DynamicDivider(height: 50)]);
      if (fromValue != null) {
        widgets.add(
          getTransactionLineDetail(
            'screens.transaction_detail.controller.operation_exchanged'.tr,
            fromValue!,
          ),
        );
      }

      if (toValue != null) {
        widgets.add(
          getTransactionLineDetail(
            'screens.transaction_detail.controller.for_label'.tr,
            toValue!,
          ),
        );
      }
    } else if (viewMode == 'SELL') {
      widgets.addAll([const DynamicDivider(height: 50)]);

      if (fromValue != null) {
        widgets.add(
          getTransactionLineDetail(
            'screens.transaction_detail.controller.operation_sold'.tr,
            fromValue!,
          ),
        );
      }
      if (toValue != null) {
        widgets.add(
          getTransactionLineDetail(
            'screens.transaction_detail.controller.for_label'.tr,
            toValue!,
          ),
        );
      }
    } else if (viewMode == 'BUY') {
      widgets.addAll([const DynamicDivider(height: 50)]);
      if (fromValue != null) {
        widgets.add(
          getTransactionLineDetail(
            'screens.transaction_detail.controller.operation_bought'.tr,
            toValue!,
          ),
        );
      }
      if (toValue != null) {
        widgets.add(
          getTransactionLineDetail(
            'screens.transaction_detail.controller.for_label'.tr,
            fromValue!,
          ),
        );
      }
    } else if (viewMode == 'CARD_PURCHASE') {
      widgets.addAll([
        const DynamicDivider(height: 20),
        Text(
          transaction!.amount.toHauvNumericString(),
          style: textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.main,
            height: 1,
          ),
        ),
        Text(
          transaction?.details['currency']['name'] ?? '',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.main,
          ),
        ),
        const DynamicDivider(height: 40),
        getTransactionLineDetail('Comercio', data['merchantName'] ?? 'N/A'),
        const DynamicDivider(height: 10),
        getTransactionLineDetail(
          'Categoría',
          data['merchantCategory'] ?? 'N/A',
        ),
        const DynamicDivider(height: 20),
      ]);
    }

    if (extra != null) {
      widgets.addAll([const DynamicDivider(height: 10), extra!]);
    }

    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  void copyTransactionId() {
    if (transaction != null) {
      Clipboard.setData(ClipboardData(text: transaction!.transactionId));
      DynamicToast.info(
        title: 'screens.transaction_detail.controller.copied_toast_title'.tr,
        description:
            'screens.transaction_detail.controller.copied_toast_description'.tr,
      );
    }
  }
}
