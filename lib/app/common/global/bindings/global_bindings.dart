//? getX
import 'package:get/get.dart';
import 'package:wiigold/app/core/services/deeplink/controller/deeplink_controller.dart';

//? CONTROLLERS
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/core/services/transactions/controllers/transaction_controller.dart';
import 'package:wiigold/app/modules/auth/controllers/auth_controller.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/home/controllers/transactions_tab_controller.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/core/services/drawer/controllers/drawer_menu_controller.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/app/core/services/location/controllers/location_controller.dart';

class GlobalBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<DeepLinkController>(DeepLinkController(), permanent: true);
    Get.put<DrawerMenuController>(DrawerMenuController(), permanent: true);
    Get.put<LocationController>(LocationController(), permanent: true);
    Get.put<FinancialController>(FinancialController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<WalletController>(WalletController(), permanent: true);
    Get.put<TransactionController>(TransactionController(), permanent: true);
    Get.put<TransactionsTabController>(
      TransactionsTabController(),
      permanent: true,
    );
    Get.put<HomeController>(HomeController(), permanent: true);

  }
}
