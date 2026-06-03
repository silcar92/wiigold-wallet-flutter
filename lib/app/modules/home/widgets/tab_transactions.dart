import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/transactions/controllers/transaction_controller.dart';
import 'package:wiigold/app/modules/home/controllers/transactions_tab_controller.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/theme/Colors.dart';

//? CONTROLLER

//? THEMES & IMAGES

class TransactionDisplayData {
  final String title;
  final String subtitle;
  final String amount;
  final String token;
  final String status;
  final IconData icon;
  final Color amountColor;
  final Map<String, dynamic> rawData;

  TransactionDisplayData({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.token,
    required this.status,
    required this.icon,
    required this.amountColor,
    required this.rawData,
  });

  factory TransactionDisplayData.fromTransaction(
    Map<String, dynamic> t,
    String currentUserEmail,
  ) {
    final details = t['details'] as Map<String, dynamic>? ?? {};

    final currency = details['currency'] as Map<String, dynamic>? ?? {};
    final origin = details['origin'] as Map<String, dynamic>? ?? {};
    final target = details['target'] as Map<String, dynamic>? ?? {};

    final operationType = (t['operationType'] as String? ?? 'unknown')
        .toLowerCase();

    final isOutgoing = (origin['email'] as String? ?? '') == currentUserEmail;

    String title = "Operación";
    IconData icon = Icons.swap_horiz_rounded;

    switch (operationType) {
      case 'transfer':
        final targetName = isOutgoing
            ? (target['full_name'] as String? ??
                      'home.tab_transactions.unknown_recipient'.tr)
                  .trim()
            : ('${origin['full_name'] ?? ''}').trim();

        title = targetName;
        icon = isOutgoing
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded;

        break;
      case 'exchange':
        title = 'home.tab_transactions.operation_exchange'.tr;
        icon = Icons.sync;
        break;

      case 'offramp':
        title = 'home.tab_transactions.operation_sell'.tr;
        icon = Icons.currency_exchange;
        break;

      case 'onramp':
        title = 'home.tab_transactions.operation_buy'.tr;
        icon = Icons.currency_exchange;
        break;
    }

    final isCredit = isOutgoing && operationType != 'withdrawal';

    final amountColor = AppColors.dark;

    var amountSign = !isCredit ? '+' : '-';
    var amountString = (details['amount'] as double? ?? 0.0)
        .toHauvNumericString();

    var currencyLabel = currency['name'] as String? ?? 'N/A';

    if (operationType == "exchange") {
      amountSign = '';

      if (details['exchange_info'] != null) {
        amountString =
            '+${(details['exchange_info']['amount_to']).toString().toHauvNumericString()} ${details['exchange_info']['asset_to']['name']}';

        currencyLabel =
            '-${(details['exchange_info']['amount_from']).toString().toHauvNumericString()} ${details['exchange_info']['asset_from']['name']}';
      } else {
        amountString = 'home.tab_transactions.data_error'.tr;
        currencyLabel = 'home.tab_transactions.data_error'.tr;
      }
    }

    if (operationType == "offramp") {
      amountSign = '';
      amountString =
          '+${(details['amount_usd']).toString().toHauvNumericString()} USD';

      currencyLabel =
          '-${(details['amount_tokens']).toString().toHauvNumericString()} ${details['currency']['name']}';
    }

    if (operationType == "onramp") {
      amountSign = '';
      amountString =
          '+${(details['amount_tokens']).toString().toHauvNumericString()} ${details['currency']['name']}';

      currencyLabel =
          '-${(details['amount_usd']).toString().toHauvNumericString()} USD';
    }

    return TransactionDisplayData(
      title: title,
      subtitle: "${t['date'] ?? ''} ${t['time'] ?? ''}".trim(),

      amount: '$amountSign$amountString',
      token: currencyLabel,

      status: (t['status'] as String? ?? 'unknown').toLowerCase(),
      icon: icon,
      amountColor: amountColor,
      rawData: t,
    );
  }
}

class TabTransactions extends StatelessWidget {
  const TabTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DynamicDivider(height: 20),
          Transactionlist(),
          const DynamicDivider(height: 100),
        ],
      ),
    );
  }
}

class Transactionlist extends GetView<TransactionsTabController> {
  const Transactionlist({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController =
        Get.find<TransactionController>();
    final ProfileController profileController = Get.find<ProfileController>();

    final TextTheme textTheme = Theme.of(context).textTheme;

    final String currentUserEmail =
        profileController.currentUser.value?.email ?? '';

    return Obx(() {
      if (controller.isLoading.value) {
        return DynamicLoading();
      }

      if (controller.transactions.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'home.tab_transactions.no_transactions_found'.tr,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.main),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final t = controller.transactions[index];
          final displayData = TransactionDisplayData.fromTransaction(
            t,
            currentUserEmail,
          );

          return TransactionItem(
            data: displayData,
            onTap: () async {
              try {
                controller.showLoading();

                final res = await transactionController.getTransactionDetail(
                  t['transaction_id'],
                );

                if (res.status != 'success' || res.data == null) {
                  DynamicToast.error(
                    title: 'form.invalidForm_title'.tr,
                    description: res.message,
                  );

                  return;
                }

                final Map<String, dynamic> payload =
                    res.data['operationType'] == "transfer"
                    ? {
                        'apiResponse': res.data as Map<String, dynamic>,
                        'perspective': t['operationType'] == 'transfer'
                            ? t['details']['origin']['email'] ==
                                      currentUserEmail
                                  ? 'SENDER'
                                  : 'RECEIVER'
                            : '',
                        'contextualData': {
                          'targetAccount':
                              t['details']['target']['wallet_address'],
                        },
                      }
                    : {'apiResponse': res.data as Map<String, dynamic>};

                controller.redirectToTransaction(payload);
              } catch (e) {
                print("e ${e.toString()}");
              } finally {
                controller.dismissLoading();
              }
            },
          );
        },
      );
    });
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionDisplayData data;
  final VoidCallback? onTap;

  const TransactionItem({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(data.icon, color: AppColors.main, size: 28),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        data.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (data.subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            data.subtitle,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.amount,
                      style: textTheme.titleSmall?.copyWith(
                        color: data.amountColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                      child: Text(
                        data.token,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.dark2,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    StatusLabelSwitcher(status: data.status),
                  ],
                ),
              ],
            ),

            const Divider(height: 30, color: AppColors.dark3),
          ],
        ),
      ),
    );
  }
}

class StatusLabelSwitcher extends StatelessWidget {
  final String status;

  const StatusLabelSwitcher({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    IconData iconData = Icons.info;
    Color statusColor = AppColors.dark3;
    String statusText = 'home.tab_transactions.status_unknown'.tr;

    switch (status.toLowerCase()) {
      case 'completed':
      case 'confirmed':
      case 'success':
        iconData = Icons.check_circle_outline;
        statusColor = AppColors.success;
        statusText = 'home.tab_transactions.status_completed'.tr;
        break;
      case 'pending_execution':
      case 'pending':
        iconData = Icons.hourglass_empty_outlined;
        statusColor = AppColors.accent;
        statusText = 'home.tab_transactions.status_pending'.tr;
        break;
      case 'funds_held_review':
        iconData = Icons.warning_amber_rounded;
        statusColor = Colors.orange;
        statusText = 'home.tab_transactions.status_under_review'.tr;
        break;
      case 'failed':
      case 'rejected':
      case 'error':
        iconData = Icons.error_outline;
        statusColor = AppColors.failure;
        statusText = 'home.tab_transactions.status_failed'.tr;
        break;
      default:
        statusText = status.isNotEmpty
            ? status[0].toUpperCase() + status.substring(1)
            : 'home.tab_transactions.status_unknown'.tr;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, size: 14, color: statusColor),
        const SizedBox(width: 4),
        Text(
          statusText,
          style: textTheme.bodySmall?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
