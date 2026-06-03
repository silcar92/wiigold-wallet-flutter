import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/home/controllers/transactions_tab_controller.dart';

//? HANDLERS
import 'package:wiigold/theme/Responsive.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS
import 'package:wiigold/app/modules/home/widgets/tab_tokens.dart';
import 'package:wiigold/app/modules/home/widgets/balance_card.dart';
import 'package:wiigold/app/modules/home/widgets/tab_transactions.dart';

//? STORAGE
import 'package:tab_container/tab_container.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.closeApp,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: true,
        showAutoBackButton: false,
        showActions: true,
        color: AppColors.appBackground,
      ),
      bottomNavigationBar: DynamicBottomNavigation(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
      onRefresh: controller.updateData,
      isContentCentered: false,
      contentPadding: EdgeInsets.zero,
      body: HomePage(),
    );
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          color: AppColors.appBackground,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Obx(
                        () => RichText(
                          text: TextSpan(
                            style: textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: 'home.home_view.welcome_message'.tr,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: controller.username.value.formatFirstName(
                                  maxLength: 12,
                                ),
                                style: textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  DynamicDivider(height: 10),
                  BalanceCard(),
                  DynamicDivider(height: 30),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.appBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [TransactionsList()],
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionsList extends GetView<TransactionsTabController> {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.45,
      child: TabContainer(
        controller: controller.tabController,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);

          return SlideTransition(
            position: Tween(
              begin: const Offset(0.2, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        selectedTextStyle: TextStyle(
          fontSize: 20 * AppResponsive.calculateScaleFactor(context),
          fontWeight: FontWeight.w600,
          color: AppColors.main,
        ),
        unselectedTextStyle: TextStyle(
          fontSize: 20 * AppResponsive.calculateScaleFactor(context),
          fontWeight: FontWeight.w600,
          color: AppColors.dark2,
        ),
        tabs:
            [
              Tab(text: 'home.transactions_tab_controller.tab_tokens'.tr),
              Tab(text: 'home.transactions_tab_controller.tab_transactions'.tr),
            ].map((materialTab) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  materialTab.text ?? '',
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: TabTokens(),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: TabTransactions(),
            ),
          ),
        ],
      ),
    );
  }
}
