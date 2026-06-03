import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/functions.dart';

import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/send/controllers/send_controller.dart';
import 'package:wiigold/app/modules/send/widgets/send_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class SendSelectorView extends StatelessWidget {
  const SendSelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.find<SendController>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      onCustomBack: () {
        Get.toNamed(AppRoutes.HOME);
      },
      appBar: DynamicAppBar(
        showLogo: false,
        title: SendAppbarTitle(),
        backbuttomFunction: () async {
          Get.toNamed(AppRoutes.HOME);
        },
      ),
      onReady: controller.chargeData,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      isContentCentered: true,
      body: SendSelectorPage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.send,
      ),
    );
  }
}

class SendSelectorPage extends GetView<SendController> {
  const SendSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return DynamicLoading();
          }

          return Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: textTheme.displayMedium?.copyWith(
                    height: 1.1,
                    fontSize: 38,
                  ),
                  children: [
                    TextSpan(text: 'send.selector_view.title_part1'.tr),
                    TextSpan(
                      text: 'send.selector_view.title_part2'.tr,
                      style: TextStyle(color: AppColors.main),
                    ),
                  ],
                ),
              ),
              DynamicDivider(height: 40),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: controller.tokens.length,
                itemBuilder: (context, index) {
                  final AssetBalance token = controller.tokens[index];
                  return _TokenCard(t: token);
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _TokenCard extends GetView<SendController> {
  final AssetBalance t;

  const _TokenCard({required this.t});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => controller.updateSelectedToken(t),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (t.asset_info?.asset_image_url != null)
              buildAssetImage(
                t.asset_info!.asset_image_url!,
                width: 40,
                height: 40,
              ),

            if (t.asset_info?.asset_image_url != null)
              DynamicDivider(height: 20),

            Text(
              t.asset_info?.name ?? 'send.selector_view.unknown_token'.tr,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              t.available ?? '0.00',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
