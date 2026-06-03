import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/buy/widgets/buy_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

// E6 — On-ramp exitoso (FIAT_AVAILABLE)
// Pantalla alcanzable desde push notification cuando admin aprueba el depósito.
class BuySuccessView extends StatelessWidget {
  BuySuccessView({super.key});

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
      body: const BuySuccessPage(),
    );
  }
}

class BuySuccessPage extends StatelessWidget {
  const BuySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    final String assetName = args['asset_name'] ?? '';
    final String amountTokens = args['amount_tokens'] ?? '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 72,
          color: AppColors.main,
        ),
        DynamicDivider(height: 4),
        Text(
          '¡Depósito confirmado!',
          textAlign: TextAlign.center,
          style: textTheme.displayLarge?.copyWith(height: 1.1),
        ),
        Text(
          'Tu depósito fue recibido y verificado. Tus fondos ya están disponibles para operar.',
          textAlign: TextAlign.center,
          style: textTheme.titleSmall?.copyWith(
            overflow: TextOverflow.visible,
            color: AppColors.dark2,
          ),
        ),
        if (amountTokens.isNotEmpty && assetName.isNotEmpty) ...[
          DynamicDivider(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.main.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.account_balance_wallet_rounded,
                    color: AppColors.main, size: 20),
                Text(
                  '$amountTokens $assetName',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.main,
                    fontWeight: FontWeight.w700,
                  ),
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
