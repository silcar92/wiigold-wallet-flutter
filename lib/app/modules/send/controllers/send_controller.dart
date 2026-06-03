import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? MIXINS

//? REPOSITORY

//?

//? WIDGETS
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/mixins/transactions_cluster_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/layout/totp_confirm_dialog.dart';
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/deeplink/controller/deeplink_controller.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

class SendController extends GetxController
    with LoadingMixin, TransactionsClusterMixin {
  final Logger logger = Logger(module: "sendController");

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR_SCANNER');

  final WalletRepository _walletRepository = WalletRepository();
  final WalletController walletController = Get.find<WalletController>();

  //? Controllers
  final ProfileController profileController = Get.find<ProfileController>();

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  final TextEditingController amountController = TextEditingController(
    text: "",
  );
  final TextEditingController targetController = TextEditingController(
    text: '',
  );

  RxString walletAddress = ''.obs;
  RxString emailAddress = ''.obs;

  final RxBool isBlocked = false.obs;

  RxList<AssetBalance> tokens = <AssetBalance>[].obs;
  final Rx<AssetBalance?> selectedToken = Rx(null);

  //? send - insert amount step
  final amountSendFormKey = GlobalKey<FormState>();

  final RxString commission = '0,00'.obs;

  Timer? _debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 700);

  //? send - insert target step
  final targetSendFormKey = GlobalKey<FormState>();

  RxString targetAddress = ''.obs;
  RxString targetName = ''.obs;
  RxString targetEmail = ''.obs;

  final RxBool isScanning = false.obs;
  final RxString scannedAddress = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    _initialize();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    Get.find<DeepLinkController>().completeDeepLinkFlow();

    super.onClose();
  }

  Future<void> _initialize() async {
    showLoading(showLoader: true);

    await getProfile();
    await getAllTokens();

    _handleInitialParams();

    dismissLoading();
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

    if (args['viewMode'] == 'ofRequest') {
      final dynamic data = args['data'] as Map<String, dynamic>;

      if (data is Map<String, dynamic>) {
        if (data['addr'] != null && data['addr'].toString().isNotEmpty) {
          targetController.text = data['addr'].toString();
        }

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

        if (data['amon'] != null && data['amon'].toString().isNotEmpty) {
          amountController.text = data['amon'].toString();
          calculateCommission();
        }
      }
    }
  }

  Future<void> chargeData() async {
    showLoading();

    await getProfile();

    await getAllTokens();

    dismissLoading();
  }

  Future<void> getAllTokens() async {
    await walletController.chargeAllBalances();

    tokens.assignAll(walletController.tokens);
  }

  getProfile() async {
    walletAddress.value =
        profileController.currentUser.value?.wallet_address ?? '';

    emailAddress.value = profileController.currentUser.value?.email ?? '';
  }

  void onAmountChanged(String value) {
    isBlocked.value = true;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(_debounceDuration, () {
      if (amountSendFormKey.currentState!.validate()) {
        calculateCommission();
      }
    });
  }

  void calculateCommission() async {
    final amountText = amountController.text.trim();

    if (amountText.isEmpty) {
      commission.value = '0.0';
      return;
    }

    isBlocked.value = true;

    try {
      ResponseApi res = await _walletRepository.getCommision({
        "amount": amountController.text.toDouble(),
        "asset_id": selectedToken.value?.asset_code,
      });

      final data = res.data;

      if (data != null) {
        commission.value = "${data['fee']}".toHauvNumericString();
      }
    } catch (e) {
      print("MyLog $e");
    } finally {
      isBlocked.value = false;
    }
  }

  Future<void> validateInsetAmountForm() async {
    if (isBlocked.value) return;

    showLoading(context: Get.context!);

    try {
      if (!amountSendFormKey.currentState!.validate()) {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'form.invalidForm_message'.tr,
        );

        return;
      }

      if (!await _amountAvilable()) {
        DynamicToast.error(title: 'send.controller.amount_not_available'.tr);

        return;
      }

      _submitInsetAmountForm();
    } catch (e) {
      print("e: ${e.toString()}");
    } finally {
      dismissLoading();
    }
  }

  Future<bool> _amountAvilable() async {
    if (selectedToken.value == null) return false;

    return (amountController.text.toDouble() + commission.value.toDouble()) <=
        selectedToken.value!.available!.toDouble();
  }

  void _submitInsetAmountForm() {
    Get.toNamed(AppRoutes.SEND_INSERT_TARGET);
  }

  void onDetect(String scan) {
    final Map<String, dynamic> decodeData = scan.decodeUriParams();

    if (decodeData['addr'] != null) {
      isScanning.value = false;
      targetController.text = decodeData['addr'];
    }
  }

  void validateInsertAddressForm() async {
    showLoading(context: Get.context!);

    try {
      late String targetToSend = scannedAddress.value.isNotEmpty
          ? scannedAddress.value
          : Validations.validationInputEmail(targetController.text) == null
          ? targetController.text.toLowerCase()
          : targetController.text;

      if (targetToSend.isEmpty) {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'send.controller.enter_or_scan_address'.tr,
        );

        return;
      }

      if (targetToSend == walletAddress.value ||
          targetToSend == emailAddress.value) {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'send.controller.enter_valid_address'.tr,
        );

        return;
      }

      final ResponseApi res = await _walletRepository.getWalletUser(
        targetToSend.trim(),
      );

      if (res.message_code != 'WALLET_FOUND') {
        if (_isExternalAddress(targetToSend.trim())) {
          _showExternalTransferDialog();
        } else {
          DynamicToast.error(title: res.message);
        }
        return;
      }

      targetAddress.value = res.data['wallet_address'];
      targetName.value =
          "${res.data['user']['first_name']} ${res.data['user']['last_name']}";

      targetEmail.value = res.data['user']['email'];

      _submitInsetAddressForm();
    } catch (e) {
      print("error: $e");
    } finally {
      dismissLoading();
    }
  }

  void _submitInsetAddressForm() {
    dismissLoading();

    Get.toNamed(AppRoutes.SEND_CONFIRM);
  }

  void submitConfirmForm() async {
    if (isLoading.value) return;

    final has2FA = await require2FAOrRedirect();
    if (!has2FA) return;
    await showTotpConfirmDialog(
      context: Get.context!,
      onConfirmed: _submitTransaction,
    );
  }

  Future<void> _submitTransaction() async {
    showLoading(context: Get.context!, showLoader: true);

    try {
      final ResponseApi res = await _walletRepository.sendTransaction({
        "to_address": targetAddress.value,
        "amount": amountController.text.toDouble(),
        "asset_id": selectedToken.value?.asset_code ?? '',
      });

      if (res.status != 'success' || res.data == null) {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: res.message,
        );

        return;
      }

      final Map<String, dynamic> payload = {
        'apiResponse': res.data as Map<String, dynamic>,
        'perspective': 'SENDER',
        'contextualData': {'targetAccount': targetAddress.value},
      };

      redirectToTransaction(payload);
    } catch (e) {
      DynamicToast.error(
        title: 'send.controller.unexpected_error_title'.tr,
        description: 'send.controller.transaction_processing_error'.trParams({
          'error': e.toString(),
        }),
      );
    } finally {
      dismissLoading();
    }
  }

  updateSelectedToken(AssetBalance t) {
    try {
      selectedToken.value = t;

      if ((selectedToken.value?.available?.toDouble() ?? 0.0) <= 0) {
        dismissLoading();

        DynamicToast.error(title: 'send.controller.token_not_available'.tr);

        return;
      }

      Future.delayed(const Duration(milliseconds: 50), () {
        Get.toNamed(AppRoutes.SEND);
      });
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: "updateSelectedToken error",
      );
    }
  }

  double getAmountFontSize(String text) {
    final length = text.length;

    if (length <= 5) return 40;
    if (length <= 8) return 35;
    if (length <= 10) return 30;

    return 28;
  }

  void _showExternalTransferDialog() {
    final context = Get.context!;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.dark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Transferencias externas no habilitadas',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(color: AppColors.light),
        ),
        content: Text(
          'Por el momento, las transferencias solo están disponibles dentro del ecosistema HAUV.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.light),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              targetController.clear();
              scannedAddress.value = '';
            },
            child: Text(
              'Entendido',
              style: textTheme.titleMedium?.copyWith(color: AppColors.main),
            ),
          ),
        ],
      ),
    );
  }

  // Detecta direcciones de blockchain externas (Ethereum/EVM: 0x + 40 hex chars)
  bool _isExternalAddress(String address) {
    return RegExp(r'^0x[0-9a-fA-F]{40}$').hasMatch(address);
  }
}
