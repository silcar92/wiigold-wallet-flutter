import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/data/models/entities/card_model.dart';
import 'package:wiigold/app/modules/card/controllers/card_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class StatusLabelSwitcher extends StatelessWidget {
  final String status;

  const StatusLabelSwitcher({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    IconData iconData;
    Color statusColor;
    String statusText;
    switch (status.toLowerCase()) {
      case 'completed':
        iconData = Icons.check_circle_outline;
        statusColor = AppColors.success;
        statusText = 'card.transaction_list.status_completed'.tr;
        break;
      case 'pending':
        iconData = Icons.hourglass_empty_outlined;
        statusColor = AppColors.accent;
        statusText = 'card.transaction_list.status_pending'.tr;
        break;
      case 'failed':
      case 'rejected':
      case 'error':
        iconData = Icons.error_outline;
        statusColor = AppColors.failure;
        statusText = 'card.transaction_list.status_failed'.tr;
        break;
      default:
        iconData = Icons.info_outline;
        statusColor = AppColors.dark3;
        statusText = status.isNotEmpty
            ? status[0].toUpperCase() + status.substring(1)
            : 'card.transaction_list.status_unknown'.tr;
        break;
    }
    return Row(
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

class CardTransactionList extends GetView<CardController> {
  const CardTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.fetchCardTransactions();
      }
    });
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Obx(() {
      if (controller.isLoadingTransactions.value &&
          controller.cardTransactions.isEmpty) {
        return const Center(child: DynamicLoading());
      }
      if (controller.cardTransactions.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'card.transaction_list.no_transactions_found'.tr,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.main),
            ),
          ),
        );
      }
      return ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount:
            controller.cardTransactions.length +
            (controller.hasMoreTransactions.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.cardTransactions.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final transaction = controller.cardTransactions[index];
          return CardTransactionItem(
            transaction: transaction,
            onTap: () => controller.goToTransactionDetail(transaction),
          );
        },
      );
    });
  }
}

class CardTransactionItem extends StatelessWidget {
  final CardTransaction transaction;
  final VoidCallback? onTap;

  const CardTransactionItem({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(transaction.createdAt);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, color: AppColors.main, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'card.transaction_list.card_purchase_title'.tr,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      formattedDate,
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
              children: [
                Text(
                  '-${transaction.amount}',
                  style: textTheme.titleSmall?.copyWith(color: AppColors.dark),
                  textAlign: TextAlign.end,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 4.0),
                  child: Text(
                    transaction.currency,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.dark2,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                StatusLabelSwitcher(status: transaction.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
