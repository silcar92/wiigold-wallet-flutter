import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//? GetX
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/modules/profile/repositories/profile_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/config/environment.dart';

//? THEME & IMAGES

//? WIDGETS

//? SHARE

class RequestController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RequestController");

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  RxString walletAddress = ''.obs;

  final WalletController walletController = Get.find<WalletController>();

  RxList<AssetBalance> tokens = <AssetBalance>[].obs;
  final Rx<AssetBalance?> selectedToken = Rx(null);

  //? Controllers
  final ProfileController profileController = Get.find<ProfileController>();

  //? request form - step 1
  final amountRequestFormKey = GlobalKey<FormState>();

  //?
  final ProfileRepository _profileRepository = ProfileRepository();

  final TextEditingController amountController = TextEditingController(
    text: '',
  );
  final amount = ''.obs;

  //? request form - step 2
  final RxString requestLink = ''.obs;

  final RxBool isQrVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    chargeData();
  }

  Future<void> chargeData() async {
    showLoading(context: Get.context!);

    await getAllTokens();

    _handleInitialParams();

    dismissLoading(context: Get.context!);
  }

  void _handleInitialParams() {
    if (Get.arguments == null || Get.arguments is! Map<String, dynamic>) {
      return;
    }

    final args = Get.arguments;

    if (args['viewMode'] == 'ofTokenView') {
      final dynamic data = jsonDecode(args['data']) as Map<String, dynamic>;

      if (data['curr'] != null && data['curr'].toString().isNotEmpty) {
        final urlToken = tokens.firstWhere(
          (token) => token.asset_code == data['curr'].toString(),
          orElse: () {
            logger.log(
              label: "DeepLink Warning",
              content: "Token from URL not found, defaulting to first token.",
            );
            return tokens.first;
          },
        );
        selectedToken.value = urlToken;
      } else {
        Get.toNamed(AppRoutes.SEND_SELECTOR);
      }
    }
  }

  getProfile() async {
    walletAddress.value =
        profileController.currentUser.value?.wallet_address ?? '';

    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _profileRepository.getUserProfile();

      final user = res.data;

      walletAddress.value = user['wallet_address'];

      if ((selectedToken.value?.asset_code ?? '') == '' ||
          walletAddress.value == '' ||
          amountController.text == '') {
        DynamicToast.error(
          title: 'request.controller.error_generating_link'.tr,
        );

        return;
      }

      requestLink.value =
          '${EnvironmentConfig.refUrl}request-link?curr=${(selectedToken.value?.asset_code ?? '')}&amon=${amountController.text}&addr=${walletAddress.value}';

      logger.log(label: requestLink.value);
    } catch (e) {
      print("e: ${e.toString()}");

      DynamicToast.error(title: 'request.controller.error_generating_link'.tr);
    } finally {
      dismissLoading();
    }
  }

  Future<void> getAllTokens() async {
    await walletController.chargeAllBalances();

    tokens.assignAll(walletController.tokens);
  }

  //? request form - step 1
  void validateRequestForm() {
    if (!amountRequestFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    amount.value = amountController.text;

    _submitRequestForm();
  }

  void _submitRequestForm() {
    _generatePaymentLink();

    Get.toNamed(AppRoutes.REQUEST_SHARE);
  }

  _generatePaymentLink() async {
    await getProfile();
  }

  //? request form - step 2
  void generateQrCode() async {
    await _generatePaymentLink();

    isQrVisible.value = true;
  }

  void hideQrCode() {
    isQrVisible.value = false;
  }

  void copyPaymentLink() async {
    await getProfile();

    try {
      Clipboard.setData(ClipboardData(text: requestLink.value));

      DynamicToast.info(title: 'request.controller.link_copied'.tr);
    } catch (e) {
      DynamicToast.error(title: 'request.controller.error_copying_link'.tr);
    }
  }

  void sharePaymentLink() async {
    await _generatePaymentLink();

    Share.share(
      'request.controller.share_link_text'.trParams({
        'amount': amountController.text,
        'tokenName': selectedToken.value?.asset_info?.name ?? '',
        'link': requestLink.value,
      }),
      subject: 'request.controller.share_link_subject'.trParams({
        'amount': amountController.text,
        'tokenName': selectedToken.value?.asset_info?.name ?? '',
      }),
    );
  }

  updateSelectedToken(AssetBalance t) {
    selectedToken.value = t;

    Get.toNamed(AppRoutes.REQUEST);
  }

  double getAmountFontSize(String text) {
    final length = text.length;

    if (length <= 5) return 52;
    if (length <= 8) return 42;
    if (length <= 10) return 36;

    return 28;
  }
}
