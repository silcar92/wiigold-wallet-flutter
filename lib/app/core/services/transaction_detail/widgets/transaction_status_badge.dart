import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

import 'package:wiigold/theme/Colors.dart';

//? COLORS & IMAGES

class TransactionStatusBadge extends StatelessWidget {
  final String status;
  final bool isDetail;

  const TransactionStatusBadge({
    super.key,
    required this.status,
    this.isDetail = false,
  });

  String _getStatusText() {
    return {
          "completed": 'screens.transaction_status_badge.completed'.tr,
          "confirmed": 'screens.transaction_status_badge.completed'.tr,
          "success": 'screens.transaction_status_badge.completed'.tr,
          "pending_execution": 'screens.transaction_status_badge.pending'.tr,
          "pending": 'screens.transaction_status_badge.pending'.tr,
          "failed": 'screens.transaction_status_badge.failed'.tr,
          "rejected": 'screens.transaction_status_badge.failed'.tr,
          "error": 'screens.transaction_status_badge.failed'.tr,
          "cancelled": 'screens.transaction_status_badge.cancelled'.tr,
        }[status.toLowerCase()] ??
        'screens.transaction_status_badge.unknown'.tr;
  }

  Color _getBackgroundColor() {
    switch (status.toLowerCase()) {
      case "completed":
      case "confirmed":
      case "success":
        return AppColors.success;
      case "pending_execution":
      case "pending":
        return AppColors.accent;
      case "failed":
      case "rejected":
      case "error":
      case "cancelled":
        return AppColors.failure;
      default:
        return AppColors.dark2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _getStatusText(),
        style: isDetail
            ? Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.dark,
              )
            : textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
      ),
    );
  }
}
