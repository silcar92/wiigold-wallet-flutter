import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLER

//? THEMES & IMAGES
import 'package:flutter_svg/svg.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/modules/home/controllers/transactions_tab_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class TabTokens extends StatelessWidget {
  const TabTokens({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const DynamicDivider(height: 20),
          const Tokenlist(),
          const DynamicDivider(height: 100),
        ],
      ),
    );
  }
}

class Tokenlist extends GetView<TransactionsTabController> {
  const Tokenlist({super.key});

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger(module: "Tokenlist");

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return DynamicLoading();
      }

      if (controller.tokens.isEmpty) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'home.tab_tokens.no_tokens_found'.tr,
                style: textTheme.bodyLarge?.copyWith(color: AppColors.main),
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.tokens.length,
        itemBuilder: (context, index) {
          final t = controller.tokens[index];

          logger.log(enable: false, label: "token", content: t.toString());

          final String mainIconUrl = t.asset_info?.asset_image_url ?? '';
          final String tokenName = t.asset_info?.name ?? 'S/N';
          final String balanceAmount =
              '${((t.asset_info?.rateChange!.currentRate?.toDouble() ?? 0.0) * (t.available?.toDouble() ?? 0.0)).toHauvNumericString(decimals: 2)}';
          final rateChange = t.asset_info?.rateChange;

          final String price = rateChange?.currentRate ?? "0,00";

          final double variation = rateChange?.variation ?? 0.0;

          final String sign = rateChange?.changeType == 'increased'
              ? '+'
              : rateChange?.changeType == 'decreased'
              ? '-'
              : '';
          final String tendency = '$sign${variation.abs().toStringAsFixed(2)}%';

          String tendencyDirection;

          switch (rateChange?.changeType) {
            case 'increased':
              tendencyDirection = 'INCREMENT';
              break;
            case 'decreased':
              tendencyDirection = 'DECREMENT';
              break;
            default:
              tendencyDirection = '';
              break;
          }

          return TokenItem(
            asset_image_url: mainIconUrl,
            token: tokenName,
            price: price.toHauvNumericString(),
            tendency: tendency,
            tendency_direction: tendencyDirection,
            balance: balanceAmount.toHauvNumericString(),
            onTap: () {
              Get.toNamed(
                AppRoutes.TOKEN,
                parameters: {
                  "data": jsonEncode({"asset": t.toJson()}),
                },
              );
            },
          );
        },
      );
    });
  }
}

class TokenItem extends StatelessWidget {
  final String asset_image_url;
  final String token;
  final String price;
  final String tendency;
  final String tendency_direction;
  final String balance;

  final VoidCallback? onTap;

  const TokenItem({
    super.key,
    required this.asset_image_url,
    required this.token,
    required this.price,
    required this.tendency,
    required this.tendency_direction,
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget buildAssetImage(
      String url, {
      double height = 35,
      double width = 35,
    }) {
      return SvgPicture.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.contain,
        placeholderBuilder: (BuildContext context) =>
            CircularProgressIndicator(),
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: width,
            height: height,
            child: Icon(Icons.circle, size: 20, color: AppColors.dark2),
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildAssetImage(asset_image_url, height: 32, width: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: price,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.dark2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: " $tendency",
                            style: textTheme.bodySmall?.copyWith(
                              color:
                                  {
                                    'INCREMENT': AppColors.success,
                                    'DECREMENT': AppColors.failure,
                                    '': AppColors.dark2,
                                  }[tendency_direction] ??
                                  AppColors.dark2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$$balance USD',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              DynamicButton(
                width: 55,
                height: 30,
                baseColor: AppColors.main,
                isGradient: false,
                radius: 50,
                onPressed: onTap,
                child: SvgPicture.asset(
                  'assets/images/icons/candlestick-chart.svg',
                  height: 20,
                ),
              ),
            ],
          ),
          const Divider(height: 30, color: AppColors.dark3),
        ],
      ),
    );
  }
}
