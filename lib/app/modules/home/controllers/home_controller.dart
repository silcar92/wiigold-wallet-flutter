import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/drawer/controllers/drawer_menu_controller.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';

import 'package:wiigold/app/modules/home/controllers/transactions_tab_controller.dart';

import 'package:wiigold/app/common/mixins/loading_mixin.dart';

import 'package:wiigold/theme/Colors.dart';

class HomeController extends GetxController with LoadingMixin {
  late TextTheme textTheme;
  final drawerController = Get.put(DrawerMenuController());

  @override
  void onReady() {
    super.onReady();

    textTheme = Theme.of(Get.context!).textTheme;
  }

  final Logger logger = Logger(module: 'HomeController');

  final ProfileController profileController = Get.find<ProfileController>();
  final WalletController walletController = Get.find<WalletController>();

  final TransactionsTabController transactionsController =
      Get.find<TransactionsTabController>();

  RxBool showVerificationMessage = false.obs;
  RxString verificationMessage = ''.obs;

  String get verificationMessageText {
    switch (verificationMessage.value) {
      case 'SUCCESS':
        return 'home.home_controller.verification_success'.tr;
      case 'FAILED':
        return 'home.home_controller.verification_error'.tr;
      case 'IMCOMPLETED':
        return 'home.home_controller.verification_incomplete'.tr;
      default:
        return '';
    }
  }

  Color get verificationMessageColor {
    switch (verificationMessage.value) {
      case 'SUCCESS':
        return AppColors.main2;
      case 'FAILED':
        return AppColors.failure;
      case 'IMCOMPLETED':
        return AppColors.failure;
      default:
        return Colors.transparent;
    }
  }

  RxString username = ''.obs;
  RxString walletAddress = ''.obs;
  RxString availableBalance = ''.obs;

  late Widget transactions;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> chargeData() async {
    showLoading();

    try {
      await getProfile();

      await walletController.chargeHauvBalance();

      availableBalance.value = walletController.mainAvailableBalance.value;

      await transactionsController.refreshData();
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: "chargeData");
    } finally {
      dismissLoading();
    }
  }

  Future<void> updateData() async {
    showLoading();

    try {
      await getProfile();

      logger.log(
        label: "asd",
        content: profileController.currentUser.value.toString(),
      );

      await walletController.chargeHauvBalance();

      availableBalance.value = walletController.mainAvailableBalance.value;

      await transactionsController.refreshData();
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: "chargeData");
    } finally {
      dismissLoading();
    }
  }

  getProfile() async {
    await profileController.chargeUser();

    final currentUser = profileController.currentUser.value;
    if (currentUser?.person_type == 'juridica') {
      username.value =
          currentUser?.company_trading_name ??
          currentUser?.company_legal_name ??
          'home.home_controller.username_placeholder'.tr;
    } else {
      username.value =
          currentUser?.first_name ??
          'home.home_controller.username_placeholder'.tr;
    }
    walletAddress.value = currentUser?.wallet_address ?? '';

    // Persona jurídica: bypass Veriff KYC, ir directo al wizard KYB
    final personType = currentUser?.person_type;
    final kybStep = currentUser?.kyb_step;
    final kybStatus = currentUser?.kyb_status;

    logger.log(
      label: 'KYB_BIFURCATION_CHECK',
      content: 'person_type=$personType | kyb_step=$kybStep | kyb_status=$kybStatus',
    );

    if (personType == 'juridica') {
      logger.log(
        label: 'KYB_REDIRECT',
        content: 'Persona jurídica detectada → redirigiendo a flujo KYB (step=$kybStep, status=$kybStatus)',
      );
      showVerificationMessage.value = false;
      _redirectJuridicaIfNeeded();
      return;
    }

    logger.log(
      label: 'KYC_NATURAL_PATH',
      content: 'Persona natural → flujo KYC normal (compliance_status)',
    );

    final cs = profileController.currentUser.value?.compliance_status;

    switch (cs.toString()) {
      case "300":
        showVerificationMessage.value = true;
        verificationMessage.value = 'IMCOMPLETED';

        break;

      case "310":
        showVerificationMessage.value = true;
        verificationMessage.value = 'IMCOMPLETED';

        DynamicToast.error(
          title: 'home.home_controller.verification_incomplete'.tr,
        );

        break;
      default:
        showVerificationMessage.value = false;
        break;
    }

    switch (cs.toString()) {
      case "300":
      case "310":
        Get.offAllNamed(AppRoutes.AUTH);
        break;
      case "330":
      case "350":
        Get.offAllNamed(AppRoutes.PROFILE_KYC);
        break;
    }
  }

  void _redirectJuridicaIfNeeded() {
    final user = profileController.currentUser.value;
    if (user == null) {
      logger.log(label: 'KYB_REDIRECT', content: 'currentUser es null — sin redirect');
      return;
    }

    final personType = user.person_type;
    final kybStatus = user.kyb_status;
    final kybStep = user.kyb_step;

    if (personType != 'juridica') return;

    if (kybStatus == 'approved') {
      logger.log(label: 'KYB_REDIRECT', content: 'KYB aprobado → queda en HOME');
      return;
    }

    if (kybStatus == 'declined') {
      logger.log(label: 'KYB_REDIRECT', content: 'KYB rechazado → KYB_STATUS');
      Get.offAllNamed(AppRoutes.KYB_STATUS);
      return;
    }

    final String targetRoute;
    switch (kybStep) {
      case 'ubo':
        targetRoute = AppRoutes.KYB_UBO_LIST;
      case 'documents':
        targetRoute = AppRoutes.KYB_DOCUMENTS;
      case 'review':
        targetRoute = AppRoutes.KYB_PENDING;
      default:
        targetRoute = AppRoutes.KYB_COMPANY_INFO;
    }

    logger.log(
      label: 'KYB_REDIRECT',
      content: 'Navegando a $targetRoute (step=$kybStep, status=$kybStatus)',
    );
    Get.offAllNamed(targetRoute);
  }

  showQr() {
    Get.toNamed(
      AppRoutes.QR,
      parameters: {
        "viewMode": "SHOW_QR",
        "accountAddress": walletAddress.value,
      },
    );
  }

  copyAccountAddress() {
    try {
      Clipboard.setData(ClipboardData(text: walletAddress.value));

      DynamicToast.info(title: 'home.home_controller.snackbar_copied'.tr);
    } catch (e) {
      DynamicToast.error(title: 'home.home_controller.snackbar_copy_error'.tr);
    }
  }

  String truncateText(String? fullName, int maxLength) {
    if (maxLength <= 0) {
      return '';
    }

    final String name = fullName ?? '';

    if (name.isEmpty) {
      return '';
    }

    if (name.length <= maxLength) {
      return name;
    } else {
      return '${name.substring(0, maxLength)}...';
    }
  }
}
