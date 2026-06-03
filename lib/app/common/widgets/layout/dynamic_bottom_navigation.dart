import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

enum BottomNavTab { send, request, exchange, buy, sell }

class DynamicBottomNavigation extends StatelessWidget {
  final Logger logger = Logger(module: "DynamicBottomNavigation");

  final BottomNavTab? currentTab;

  DynamicBottomNavigation({super.key, this.currentTab});

  void _navigateToWithLoading(String route, {Map<String, String>? parameters}) {
    Future.delayed(const Duration(milliseconds: 50), () {
      Get.toNamed(route, parameters: parameters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final int? currentIndex = currentTab?.index;

    final List<Map<String, dynamic>> bottomNavSource = [
      {
        "tab": BottomNavTab.send,
        "route": AppRoutes.SEND_SELECTOR,
        "icon": Icons.arrow_upward,
        "label": 'widgets.dynamic_bottom_navigation.send'.tr,
      },
      {
        "tab": BottomNavTab.request,
        "route": AppRoutes.REQUEST_SELECTOR,
        "icon": Icons.arrow_downward,
        "label": 'widgets.dynamic_bottom_navigation.request'.tr,
      },
      {
        "tab": BottomNavTab.exchange,
        "route": AppRoutes.EXCHANGE,
        "icon": Icons.sync,
        "label": 'widgets.dynamic_bottom_navigation.exchange'.tr,
      },
      {
        "tab": BottomNavTab.buy,
        "route": AppRoutes.BUY_SELECTOR,
        "icon": Icons.currency_exchange,
        "label": 'widgets.dynamic_bottom_navigation.buy'.tr,
      },
      {
        "tab": BottomNavTab.sell,
        "route": AppRoutes.SELL_SELECTOR,
        "icon": Icons.payments_outlined,
        "label": 'widgets.dynamic_bottom_navigation.sell'.tr,
      },
    ];

    List<double>? getStops({int? index}) {
      switch (index) {
        case 0:
          return [0, 0, 0, 0.4];
        case 1:
          return [0, 0.25, 0.33, 0.5];
        case 2:
          return [0.2, 0.45, 0.5, 0.75];
        case 3:
          return [0.4, 0.68, 0.76, 0.9];
        case 4:
          return [0.6, 1, 1, 1];
        default:
          return null;
      }
    }

    return SafeArea(
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 6),
        margin: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
        decoration: BoxDecoration(
          gradient: currentIndex == null
              ? null
              : LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.main.withAlpha(20),
                    AppColors.main.withAlpha(20),
                    Colors.transparent,
                  ],
                  stops: getStops(index: currentIndex),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: AppColors.appAltBackground,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: bottomNavSource.map((i) {
            bool isSelected = i['tab'] == currentTab;

            return GestureDetector(
              onTap: () {
                if (!isSelected) {
                  _navigateToWithLoading(
                    i['route'],
                    parameters: i['parameters'],
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    i['icon'],
                    color: isSelected ? AppColors.dark : AppColors.main,
                    size: 26,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    i['label'],
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.dark : AppColors.main,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
