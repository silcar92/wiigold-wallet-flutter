import 'package:flutter/material.dart';
import 'package:wiigold/app/data/models/constants/kyc_limits.dart';
import 'package:wiigold/theme/Colors.dart';

class KycLimitsCard extends StatelessWidget {
  final String? complianceStatus;

  const KycLimitsCard({super.key, required this.complianceStatus});

  @override
  Widget build(BuildContext context) {
    final tier = KycLimits.forStatus(complianceStatus);
    if (tier == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.appAltBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dark3),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _TierBadge(tier: tier),
          Text(
            tier.description,
            style: textTheme.bodySmall?.copyWith(color: AppColors.dark2, fontSize: (textTheme.bodySmall?.fontSize ?? 12) + 2),
          ),
          const Divider(color: AppColors.dark3, height: 1),
          _LimitsTable(tier: tier, textTheme: textTheme),
        ],
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  final KycTier tier;
  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tier.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tier.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        tier.name,
        style: TextStyle(
          color: tier.color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _LimitsTable extends StatelessWidget {
  final KycTier tier;
  final TextTheme textTheme;

  const _LimitsTable({required this.tier, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        _LimitRow(
          label: 'Por operación',
          value: tier.perOperation,
          textTheme: textTheme,
        ),
        _LimitRow(
          label: 'Por día',
          value: tier.perDay,
          textTheme: textTheme,
        ),
        _LimitRow(
          label: 'Por mes',
          value: tier.perMonth,
          textTheme: textTheme,
        ),
      ],
    );
  }
}

class _LimitRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textTheme;

  const _LimitRow({
    required this.label,
    required this.value,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: AppColors.dark2, fontSize: (textTheme.bodySmall?.fontSize ?? 12) + 2),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
            fontSize: (textTheme.bodySmall?.fontSize ?? 12) + 2,
          ),
        ),
      ],
    );
  }
}
