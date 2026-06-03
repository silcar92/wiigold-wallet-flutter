import 'dart:convert';
import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/config/environment.dart';

//? EXTENSIONS

//? MIXINS

//? others

class QrController extends GetxController with LoadingMixin {
  Logger logger = Logger(module: "QrController");

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_VIEW');

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  RxString viewMode = ''.obs;

  late String appbarTitle = '';
  late String accountAddress = '';

  RxBool showQr = false.obs;

  @override
  void onInit() async {
    super.onInit();

    showQr.value = false;

    _handleInitialParams();
  }

  void _handleInitialParams() {
    final params = Get.parameters;

    if (params["viewMode"] != null) {
      /*
      -SHOW_QR
      -SCAM_QR
       */
      viewMode.value = params["viewMode"]!;
    }

    if (params["accountAddress"] != null) {
      accountAddress =
          '${EnvironmentConfig.refUrl}?addr=${params["accountAddress"]!}';

      showQr.value = true;
    }
  }

  void toggleMode() {
    if (viewMode.value == 'SCAM_QR') {
      viewMode.value = 'SHOW_QR';

      final HomeController homeController = Get.find<HomeController>();

      accountAddress =
          '${EnvironmentConfig.refUrl}?addr=${homeController.walletAddress.value}';

      showQr.value = true;
    } else {
      viewMode.value = 'SCAM_QR';
      showQr.value = false;
    }
  }

  bool invalidEntry(dynamic e) {
    e = e.toString();

    if (e.isEmpty || e.toString() == '') return true;

    return false;
  }

  void onDetect(String scan) {
    logger.log(label: "onDetect", customData: scan.decodeUriParams());

    final scanDecode = scan.decodeUriParams();

    if (invalidEntry(scanDecode['curr']) ||
        invalidEntry(scanDecode['addr']) ||
        invalidEntry(scanDecode['amon'])) {
      DynamicToast.error(
        title: "Error",
        description: "Informacion de transaccion incompleta",
      );

      return;
    }

    final Map<String, dynamic> decodedData = scan.decodeUriParams();

    Get.offAllNamed(
      AppRoutes.SEND,
      arguments: {"viewMode": 'ofRequest', "data": decodedData},
    );
  }
}
