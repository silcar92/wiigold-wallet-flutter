import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/buy/widgets/buy_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

// E7 — On-ramp conciliación pendiente (FIAT_CONCILIATION_RUNNING)
class BuyPendingView extends StatelessWidget {
  BuyPendingView({super.key});

  final _isLoading = false.obs;
  final _showLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    return DynamicAppScaffold(
      isLoading: _isLoading,
      showLoader: _showLoader,
      appBar: DynamicAppBar(
        showLogo: false,
        showActions: false,
        showAutoBackButton: false,
        title: BuyAppbarTitle(),
      ),
      isContentCentered: true,
      body: const BuyPendingPage(),
    );
  }
}

class BuyPendingPage extends StatelessWidget {
  const BuyPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    final String assetName = args['asset_name'] ?? '';
    final String amountTokens = args['amount_tokens'] ?? '';
    final String amountUsd = args['amount_usd'] ?? '';
    final String transactionId = args['transaction_id'] ?? '';
    final bool isFundsHeld = args['status'] == 'funds_held_review';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Icon(
          isFundsHeld ? Icons.warning_amber_rounded : Icons.hourglass_top_rounded,
          size: 72,
          color: isFundsHeld ? Colors.orange : AppColors.dark2,
        ),
        DynamicDivider(height: 4),
        Text(
          isFundsHeld ? 'Tu depósito está en revisión' : 'Tu depósito está en proceso',
          textAlign: TextAlign.center,
          style: textTheme.displayLarge?.copyWith(height: 1.1),
        ),
        Text(
          isFundsHeld
              ? 'Detectamos una inconsistencia entre la titularidad de la cuenta de origen y tu perfil registrado. Tu operación será revisada antes de continuar.'
              : 'Recibimos tu solicitud. Estamos validando la recepción y conciliación de los fondos. Te notificaremos cuando el saldo esté disponible.',
          textAlign: TextAlign.center,
          style: textTheme.titleSmall?.copyWith(
            overflow: TextOverflow.visible,
            color: AppColors.dark2,
          ),
        ),
        if (isFundsHeld)
          Text(
            'Si tienes dudas escríbenos a soporte@hauvtrading.com',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
          ),
        if (amountTokens.isNotEmpty && assetName.isNotEmpty) ...[
          DynamicDivider(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.dark.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              spacing: 6,
              children: [
                if (amountUsd.isNotEmpty)
                  _InfoRow(
                    label: 'Monto pagado',
                    value: '\$$amountUsd USD',
                    textTheme: textTheme,
                  ),
                _InfoRow(
                  label: 'A recibir',
                  value: '$amountTokens $assetName',
                  textTheme: textTheme,
                ),
                if (transactionId.isNotEmpty)
                  _InfoRow(
                    label: 'Referencia',
                    value: '#$transactionId',
                    textTheme: textTheme,
                  ),
              ],
            ),
          ),
        ],
        DynamicDivider(height: 8),
        DynamicButton(
          width: double.infinity,
          isGradient: true,
          baseColor: AppColors.main,
          onPressed: () => Get.offAllNamed(AppRoutes.HOME),
          child: Text(
            'Ir al inicio',
            style: textTheme.titleLarge?.copyWith(color: AppColors.light),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.textTheme,
  });

  final String label;
  final String value;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: AppColors.dark2),
        ),
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
