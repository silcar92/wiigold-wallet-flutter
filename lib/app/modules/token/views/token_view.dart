import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? THEMES & IMAGES
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/functions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';

//? WIDGETS
import 'package:wiigold/app/modules/token/controllers/token_controller.dart';
import 'package:wiigold/app/modules/token/widgets/main_chart.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/config/environment.dart';
import 'package:wiigold/theme/Colors.dart';

class TokenView extends GetView<TokenController> {
  const TokenView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.toHome,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showActions: false,
        showLogo: false,
        backbuttomFunction: () {
          Get.find<HomeController>().chargeData();

          Get.offAllNamed(AppRoutes.HOME);
        },
      ),
      bottomNavigationBar: DynamicBottomNavigation(),
      onRefresh: controller.chargeData,
      isContentCentered: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      body: TokenPage(),
    );
  }
}

class TokenPage extends GetView<TokenController> {
  const TokenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TokenHeader(),
            DynamicDivider(height: 50),
            BalanceCard(),
            DynamicDivider(height: 50),

            Obx(() {
              if (controller.t.value?.asset_code !=
                  EnvironmentConfig.usdtToken) {
                return Column(
                  children: [
                    IndicatorsCard(),
                    DynamicDivider(height: 50),
                    MainChart(),
                    DynamicDivider(height: 50),
                  ],
                );
              }

              return SizedBox.shrink();
            }),
          ],
        ),
      ],
    );
  }
}

class TokenHeader extends GetView<TokenController> {
  const TokenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      spacing: 10,
      children: [
        Flex(
          direction: Axis.horizontal,
          spacing: 8,
          children: [
            Obx(
              () => Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildAssetImage(
                    controller.t.value?.asset_info?.asset_image_url ?? '',
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
            ),

            Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Obx(
                  () => Text(
                    controller.t.value?.asset_info?.name ?? '',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Obx(
                  () => RichText(
                    text: TextSpan(
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.success,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "${controller.price.value} USD (${controller.tendency.value})",
                          style: textTheme.bodyLarge?.copyWith(
                            color:
                                {
                                  'INCREMENT': AppColors.success,
                                  'DECREMENT': AppColors.failure,
                                  '': AppColors.dark2,
                                }[controller.tendencyDirection.value] ??
                                AppColors.dark2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        TextSpan(
                          text: 'token.view.today'.tr,
                          style: textTheme.bodyMedium?.copyWith(
                            color:
                                {
                                  'INCREMENT': AppColors.success,
                                  'DECREMENT': AppColors.failure,
                                  '': AppColors.dark2,
                                }[controller.tendencyDirection.value] ??
                                AppColors.dark2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class BalanceCard extends GetView<TokenController> {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        Text(
          'token.view.current_balance'.tr,
          style: textTheme.displayLarge?.copyWith(fontSize: 24, height: 1),
        ),
        DynamicDivider(height: 16),

        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Obx(
              () => Text(
                '\$${((controller.t.value!.asset_info?.rateChange!.currentRate?.toDouble() ?? 0.0) * (controller.t.value?.available?.toDouble() ?? 0.0)).toHauvNumericString(decimals: 2)}',
                style: textTheme.displayMedium?.copyWith(
                  color: AppColors.main,
                  height: 1,
                ),
              ),
            ),
            Text(
              'USD',
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.main,
                fontSize: 22,

                height: 1,
              ),
            ),
          ],
        ),

        DynamicDivider(height: 6),

        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            buildAssetImage(
              controller.t.value?.asset_info?.asset_image_url ?? '',
              height: 18,
              width: 18,
            ),

            Text(
              (controller.t.value?.available?.toDouble() ?? 0.0)
                  .toHauvNumericString(),
              style: textTheme.displaySmall?.copyWith(
                color: AppColors.dark2,

                height: 1,
              ),
            ),
          ],
        ),

        DynamicDivider(height: 40),

        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DynamicButton(
              width: MediaQuery.of(context).size.width * 0.25,
              baseColor: AppColors.transparent,
              borderColor: AppColors.main,
              radius: 10,
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  DynamicDivider(height: 10),
                  Icon(
                    Icons.currency_exchange,
                    color: AppColors.main,
                    size: 20,
                  ),
                  Text(
                    'token.view.buy_button'.tr,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Get.toNamed(
                  AppRoutes.BUY,
                  parameters: {
                    "data": jsonEncode({"asset": controller.t.toJson()}),
                  },
                );
              },
            ),

            DynamicButton(
              width: MediaQuery.of(context).size.width * 0.25,
              baseColor: AppColors.transparent,
              borderColor: AppColors.main,
              radius: 10,
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  DynamicDivider(height: 10),
                  Icon(
                    Icons.payments_outlined,
                    color: AppColors.main,
                    size: 20,
                  ),
                  Text(
                    'token.view.sell_button'.tr,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                if ((controller.t.value?.available?.toDouble() ?? 0.0) <= 0) {
                  DynamicToast.error(
                    title: 'token.view.no_balance_available'.tr,
                  );

                  return;
                }

                Get.toNamed(
                  AppRoutes.SELL,
                  parameters: {
                    "data": jsonEncode({"asset": controller.t.toJson()}),
                  },
                );
              },
            ),

            DynamicButton(
              width: MediaQuery.of(context).size.width * 0.25,
              baseColor: AppColors.transparent,
              borderColor: AppColors.main,
              radius: 10,
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  DynamicDivider(height: 10),
                  Icon(Icons.arrow_upward, color: AppColors.main, size: 20),
                  Text(
                    'token.view.send_button'.tr,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                if ((controller.t.value?.available?.toDouble() ?? 0.0) <= 0) {
                  DynamicToast.error(
                    title: 'send.controller.token_not_available'.tr,
                  );

                  return;
                }

                Get.toNamed(
                  AppRoutes.SEND,
                  arguments: {
                    "viewMode": 'ofTokenView',
                    "data": jsonEncode({
                      "curr": controller.t.value?.asset_code,
                    }),
                  },
                );
              },
            ),
          ],
        ),

        DynamicDivider(height: 15),

        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DynamicButton(
              width: MediaQuery.of(context).size.width * 0.25,
              baseColor: AppColors.transparent,
              borderColor: AppColors.main,
              radius: 10,
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  DynamicDivider(height: 10),
                  Icon(Icons.arrow_downward, color: AppColors.main, size: 20),
                  Text(
                    'token.view.request_button'.tr,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Get.toNamed(
                  AppRoutes.REQUEST,
                  arguments: {
                    "viewMode": 'ofTokenView',
                    "data": jsonEncode({
                      "curr": controller.t.value?.asset_code,
                    }),
                  },
                );
              },
            ),

            DynamicButton(
              width: MediaQuery.of(context).size.width * 0.25,
              baseColor: AppColors.transparent,
              borderColor: AppColors.main,
              radius: 10,
              child: Flex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  DynamicDivider(height: 10),
                  Icon(
                    Icons.payments_outlined,
                    color: AppColors.main,
                    size: 20,
                  ),
                  Text(
                    'token.view.exchange_button'.tr,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.main,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Get.toNamed(
                  AppRoutes.EXCHANGE,
                  arguments: {
                    "viewMode": 'ofTokenView',
                    "data": jsonEncode({
                      "curr": controller.t.value?.asset_code,
                    }),
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class IndicatorsCard extends GetView<TokenController> {
  const IndicatorsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        Text(
          'token.view.market_indicators'.tr,
          style: textTheme.displayLarge?.copyWith(
            fontSize: 24,
            height: 1,
            overflow: TextOverflow.visible,
          ),
        ),
        DynamicDivider(height: 20),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: AppColors.light, width: 2),
                  color: AppColors.light,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10,
                        children: [
                          Text(
                            "${controller.price.value} USD",
                            style: textTheme.displaySmall?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildAssetImage(
                                controller
                                        .t
                                        .value
                                        ?.asset_info
                                        ?.asset_image_url ??
                                    '',
                                height: 18,
                                width: 18,
                              ),

                              Text(
                                'token.view.current_price'.tr,
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: AppColors.light, width: 2),
                  color: AppColors.light,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10,
                        children: [
                          Text(
                            controller.tendency.value,
                            style: textTheme.displaySmall?.copyWith(
                              color: AppColors.success,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildAssetImage(
                                controller
                                        .t
                                        .value
                                        ?.asset_info
                                        ?.asset_image_url ??
                                    '',
                                height: 18,
                                width: 18,
                              ),
                              Text(
                                'token.view.daily_change'.tr,
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        DynamicDivider(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flex(
              direction: Axis.vertical,
              children: [
                Text(
                  'token.view.data_updated_every_minute'.tr,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    color: AppColors.accent,
                  ),
                ),
                Obx(
                  () => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'token.view.last_update'.tr,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: controller.lastPriceUpdate.value,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
