import 'package:get/get.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/mixins/transactions_cluster_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_dialog.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/data/models/entities/card_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/modules/card/repositories/card_repository.dart';

class CardController extends GetxController
    with LoadingMixin, TransactionsClusterMixin {
  final Logger logger = Logger(module: "CardController");
  final CardRepository _cardRepository = CardRepository();

  final WalletController walletController = Get.find<WalletController>();

  RxString availableBalance = ''.obs;

  final Rx<CardModel?> card = Rx<CardModel?>(null);
  final RxBool hasActiveCard = false.obs;

  final RxList<CardTransaction> cardTransactions = <CardTransaction>[].obs;
  final RxBool isLoadingTransactions = false.obs;
  final RxBool hasMoreTransactions = true.obs;
  int _currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    loadInitialCardData();
    chargeData();
  }

  Future<void> chargeData() async {
    logger.log(label: "chargeData");
    showLoading();
    try {
      await walletController.chargeHauvBalance();
      availableBalance.value = walletController.wiigoldAvailableBalance.value;
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: "chargeData");
    } finally {
      dismissLoading();
    }
  }

  void goToTransactionDetail(CardTransaction transaction) {
    final payload = {
      'apiResponse': {
        'operationType': 'CARD_PURCHASE',
        'transaction_id': transaction.transactionId,
        'amount': transaction.amount,
        'currency': transaction.currency,
        'status': transaction.status,
        'processing_status': transaction.processingStatus,
        'merchant_info': {
          'merchant_id': transaction.merchantInfo.merchantId,
          'merchant_category_code':
          transaction.merchantInfo.merchantCategoryCode,
        },
        'created_at': transaction.createdAt.toIso8601String(),
      },
    };
    redirectToTransaction(payload);
  }

  Future<void> loadInitialCardData() async {
    showLoading(context: Get.context!, showLoader: true);
    try {
      final ResponseApi res = await _cardRepository.getCardDetails();
      if (res.code == 404) {
        hasActiveCard.value = false;
        return;
      }
      if (res.status == 'error') {
        hasActiveCard.value = false;
        DynamicToast.error(title: AppErrors.getErrorLabel(res.message));
        return;
      }
      card.value = CardModel.fromJson(res.data);
      hasActiveCard.value = true;
      fetchCardTransactions(isInitialLoad: true);
    } catch (e, s) {
      hasActiveCard.value = false;
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'loadInitialCardData',
        reason: 'Falló la carga inicial de datos de la tarjeta.',
      );
    } finally {
      dismissLoading();
    }
  }

  Future<void> fetchCardTransactions({bool isInitialLoad = false}) async {
    if (isLoadingTransactions.value) return;
    if (isInitialLoad) {
      _currentPage = 1;
      hasMoreTransactions.value = true;
      cardTransactions.clear();
    }
    if (!hasMoreTransactions.value) return;
    isLoadingTransactions.value = true;
    try {
      final res = await _cardRepository.getCardTransactions(page: _currentPage);
      if (res.status == 'success' && res.data != null) {
        final List<dynamic> results = res.data['results'] as List<dynamic>;
        final newTransactions = results
            .map((t) => CardTransaction.fromJson(t))
            .toList();
        cardTransactions.addAll(newTransactions);
        if (res.data['next'] == null) {
          hasMoreTransactions.value = false;
        }
        _currentPage++;
      } else {
        hasMoreTransactions.value = false;
      }
    } catch (e, s) {
      hasMoreTransactions.value = false;
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'fetchCardTransactions',
        reason: 'Falló la carga de transacciones de tarjeta.',
      );
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  Future<void> activateVirtualCard() async {
    DynamicDialog(
      context: Get.context!,
      title: 'card.controller.confirm_dialog_title'.tr,
      message: 'card.controller.activate_dialog_message'.tr,
      confirmButtonText: 'card.controller.confirm_button'.tr,
      onConfirm: () => _submitActivateVirtualCard(),
      onCancel: () => Get.back(),
    );
  }

  Future<void> _submitActivateVirtualCard() async {
    Get.back();
    showLoading(context: Get.context!, showLoader: true);
    try {
      final ResponseApi res = await _cardRepository.activateVirtualCard();
      if (res.status == 'error') {
        DynamicToast.error(
          title: 'card.controller.activation_error_title'.tr,
          description: AppErrors.getErrorLabel(res.message),
        );
        return;
      }
      DynamicToast.success(
        title: 'card.controller.activation_success_title'.tr,
        description: 'card.controller.activation_success_description'.tr,
      );
      await loadInitialCardData();
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'activateVirtualCard',
        reason: 'Falló la activación de la tarjeta virtual.',
      );
    } finally {
      dismissLoading();
    }
  }

  Future<void> toggleFreezeCard() async {
    if (card.value == null) return;
    showLoading(context: Get.context!, showLoader: true);
    final bool futureFreezeState = !card.value!.isFrozen;
    try {
      final ResponseApi res = await _cardRepository.setCardFreezeStatus(
        futureFreezeState,
      );
      if (res.status == 'error') {
        DynamicToast.error(
          title: 'card.controller.toggle_freeze_error_title'.tr,
          description: AppErrors.getErrorLabel(res.message),
        );
        return;
      }
      card.value = card.value!.copyWith(isFrozen: futureFreezeState);
      DynamicToast.success(
        title: 'card.controller.toggle_freeze_success_title'.tr,
        description: futureFreezeState
            ? 'card.controller.card_frozen_message'.tr
            : 'card.controller.card_unfrozen_message'.tr,
      );
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'toggleFreezeCard',
        reason: 'Falló el cambio de estado de congelado de la tarjeta.',
      );
    } finally {
      dismissLoading();
    }
  }

  Future<void> blockCard() async {
    Get.defaultDialog(
      title: "card.controller.block_dialog_title".tr,
      middleText: "card.controller.block_dialog_message".tr,
      textConfirm: "card.controller.block_dialog_confirm_button".tr,
      textCancel: "card.controller.block_dialog_cancel_button".tr,
      onConfirm: () async {
        Get.back();
        showLoading(context: Get.context!, showLoader: true);
        try {
          final ResponseApi res = await _cardRepository.blockCard();
          if (res.status == 'error') {
            DynamicToast.error(title: AppErrors.getErrorLabel(res.message));
            return;
          }
          DynamicToast.success(title: 'card.controller.block_success_message'.tr);
          await loadInitialCardData();
        } catch (e, s) {
          await logger.crashlyticsError(
            error: e,
            stackTrace: s,
            tag: 'blockCard',
            reason: 'Falló el bloqueo permanente de la tarjeta.',
          );
        } finally {
          dismissLoading();
        }
      },
    );
  }

  Future<void> requestPhysicalCard() async {
    showLoading(context: Get.context!, showLoader: true);
    try {
      final ResponseApi res = await _cardRepository.requestPhysicalCard();
      if (res.status == 'error') {
        DynamicToast.error(
          title: 'card.controller.request_physical_error_title'.tr,
          description: AppErrors.getErrorLabel(res.message),
        );
        return;
      }
      DynamicToast.success(
        title: 'card.controller.request_physical_success_title'.tr,
        description: 'card.controller.request_physical_success_description'.tr,
      );
      await loadInitialCardData();
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'requestPhysicalCard',
        reason: 'Falló la solicitud de la tarjeta física.',
      );
    } finally {
      dismissLoading();
    }
  }
}