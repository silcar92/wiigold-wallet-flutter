import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/functions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_checkbox.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_image_picker.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_dialog.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_show_payment_method_info.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/data/models/entities/payment_methods_model.dart';
import 'package:wiigold/app/data/models/entities/redeems_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/data/models/responses/easypost_model.dart';
import 'package:wiigold/app/data/providers/easypost_provider.dart';
import 'package:wiigold/app/modules/redeem/repositories/redeem_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

enum RedeemStepVisual {
  pendingQuote,
  paymentPending,
  paymentVerified,
  shipped;

  String get label {
    switch (this) {
      case RedeemStepVisual.pendingQuote:
        return 'redeem.detail_controller.step_pending_quote'.tr;
      case RedeemStepVisual.paymentPending:
        return 'redeem.detail_controller.step_payment_pending'.tr;
      case RedeemStepVisual.paymentVerified:
        return 'redeem.detail_controller.step_payment_verified'.tr;
      case RedeemStepVisual.shipped:
        return 'redeem.detail_controller.step_shipped'.tr;
    }
  }
}

class StepData {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final Widget? content;

  StepData(this.title, this.subtitle, {this.isCompleted = false, this.content});
}

class RedeemDetailController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RedeemDetailController");
  final RedeemRepository _redeemRepository = RedeemRepository();
  final EasypostProvider _easypostProvider = EasypostProvider();
  late final TextTheme textTheme;

  final FinancialController _financialController = Get.find();
  final WalletController walletController = Get.find<WalletController>();

  final paymentMethodFormKey = GlobalKey<FormState>();

  RxList<AssetBalance> tokens = <AssetBalance>[].obs;

  RxList<PaymentMethodType> get availablePaymentMethods =>
      _financialController.paymentMethods;
  late RxList<PaymentMethod> availablePaymentMethodsDetail =
      <PaymentMethod>[].obs;

  final RxInt currentStep = (-1).obs;
  final Rx<Redeem?> r = Rx<Redeem?>(null);
  final RxBool showPaymentForm = false.obs;
  final RxBool payWithTokens = false.obs;
  final Rx<AssetBalance?> selectedTokenFrom = Rx(null);
  final RxBool isPaymentWithTokenBlocked = true.obs;

  final Rx<EasypostTracker?> easypostTracker = Rx<EasypostTracker?>(null);
  final RxBool isFetchingTracker = false.obs;

  final TextEditingController proofController = TextEditingController();
  final ValueNotifier<String?> proofImageController = ValueNotifier(null);

  @override
  void onInit() {
    super.onInit();
    textTheme = Theme.of(Get.context!).textTheme;
    handleParams();
    chargeData();
  }

  @override
  void onClose() {
    proofController.dispose();
    proofImageController.dispose();
    super.onClose();
  }

  void _initializePaymentMethods() async {
    try {
      if (_financialController.paymentMethods.isEmpty) {
        await _financialController.initializePaymentMethods();
      }

      if (availablePaymentMethods.isNotEmpty) {
        getPaymentMethodDetails(availablePaymentMethods.value[0].id);
      }
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: '_initializePaymentMethods',
      );
    }
  }

  void handleParams() {
    final params = Get.parameters;
    if (params['data'] != null) {
      try {
        final data = jsonDecode(params['data']!);
        if (data['redeem'] != null) {
          r.value = Redeem.fromJson(data['redeem']);
          _initializeCurrentStep();
          _initializePaymentMethods();
        }
      } catch (e, s) {
        logger.crashlyticsError(error: e, stackTrace: s, tag: 'handleParams');
      }
    }
  }

  Future<void> chargeData() async {
    if (r.value == null) return;
    final reference = r.value!.withdrawal_reference ?? '';
    if (reference.isEmpty) return;

    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _redeemRepository.redeemDetail(reference);
      if (res.status == 'success' && res.data is Map<String, dynamic>) {
        r.value = Redeem.fromJson(res.data);
        _initializeCurrentStep();
        _initializePaymentMethods();
      } else {
        logger.crashlyticsReport(
          tag: 'RedeemDetailApiError',
          reportMessage: 'No se pudieron refrescar los detalles del redeem',
        );
      }
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'chargeData');
    } finally {
      dismissLoading();
    }
  }

  void _initializeCurrentStep() {
    if (r.value == null) return;

    currentStep.value = calculateCurrentVisualStepIndex();

    if (r.value?.status.value == "shipped") {
      fetchTrackingDetails();
    }
  }

  void toggleStep(int index) {
    if (r.value == null) return;

    final currentStatusIndex = calculateCurrentVisualStepIndex();
    final bool isCompleted = index <= currentStatusIndex;

    if (isCompleted) {
      final newStep = (currentStep.value == index) ? -1 : index;
      currentStep.value = newStep;

      final visualStep = stepperVisualSteps[index];

      if (newStep != -1 &&
          visualStep == RedeemStepVisual.shipped &&
          easypostTracker.value == null) {
        fetchTrackingDetails();
      }
    }
  }

  void confirmPayment() {
    showPaymentForm.value = true;
  }

  Future<void> cancelRedeem() async {
    DynamicDialog(
      context: Get.context!,
      title: 'redeem.detail_controller.warning_dialog_title'.tr,
      message: 'redeem.detail_controller.cancel_dialog_message'.tr,
      confirmButtonText: 'redeem.detail_controller.confirm_button'.tr,
      confirmButtonColor: AppColors.failure,
      onConfirm: () {
        Get.back();
        _submiteCancelRedeem();
      },
      cancelButtonText: 'redeem.detail_controller.cancel_button'.tr,
      onCancel: () => Get.back(),
    );
  }

  _submiteCancelRedeem() async {
    try {
      showLoading(context: Get.context!);

      final ResponseApi res = await _redeemRepository.setDecision(
        r.value?.withdrawal_reference ?? '',
        {"accept": false},
      );
      if (res.status == 'error') {
        DynamicToast.error(
          title: 'redeem.detail_controller.error_title'.tr,
          description: AppErrors.getErrorLabel(res.message),
        );
        return;
      }
      Get.offAllNamed(AppRoutes.REDEEM);
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'cancelRedeem');
    } finally {
      dismissLoading();
    }
  }

  void validatePaymentForm() async {
    showLoading(context: Get.context!, showLoader: true);

    if (!paymentMethodFormKey.currentState!.validate()) {
      dismissLoading();
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );
      return;
    }

    _submitPaymentProof();
  }

  Future<void> _submitPaymentProof() async {
    try {
      showLoading(context: Get.context!, showLoader: true);

      final ResponseApi res = await _redeemRepository
          .setDecision(r.value?.withdrawal_reference ?? '', {
            "accept": true,
            "payment_with_tokens": payWithTokens.value,
            "asset_code": selectedTokenFrom.value?.asset_code ?? '',
            "payment_proof": proofImageController.value,
            "payment_reference": proofController.text,
          });

      if (res.status == 'error') {
        DynamicToast.error(
          title: 'redeem.detail_controller.error_title'.tr,
          description: res.message,
        );
        return;
      }

      chargeData();
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: '_submitPaymentProof',
      );
    } finally {
      dismissLoading();
    }
  }

  Future<void> fetchTrackingDetails() async {
    final trackingNumber = r.value?.trackingNumber;
    final carrier = r.value?.carrierCompany;

    if (trackingNumber == null ||
        trackingNumber.isEmpty ||
        carrier == null ||
        carrier.isEmpty) {
      logger.log(
        label: 'fetchTrackingDetails',
        content: 'Falta número de tracking o transportista.',
      );
      return;
    }

    isFetchingTracker.value = true;
    try {
      final response = await _easypostProvider.post(
        EasypostEndpoints.trackers,
        body: {
          'tracker': {'tracking_code': trackingNumber, 'carrier': carrier},
        },
      );
      easypostTracker.value = EasypostTracker.fromJson(response);
    } catch (e, s) {
      logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'fetchTrackingDetails',
      );

      DynamicToast.error(
        title: 'redeem.detail_controller.tracking_error_title'.tr,
        description: 'redeem.detail_controller.tracking_error_description'.tr,
      );
    } finally {
      isFetchingTracker.value = false;
    }
  }

  List<RedeemStepVisual> get stepperVisualSteps => RedeemStepVisual.values;

  int calculateCurrentVisualStepIndex() {
    if (r.value == null) return -1;
    final step = mapStatusToVisualStep(r.value!.status);
    return step?.index ?? -1;
  }

  RedeemStepVisual? mapStatusToVisualStep(RedeemStatus status) {
    switch (status) {
      case RedeemStatus.pendingQuote:
        return RedeemStepVisual.pendingQuote;
      case RedeemStatus.quoted:
      case RedeemStatus.accepted:
        return RedeemStepVisual.paymentPending;
      case RedeemStatus.paymentPending:
      case RedeemStatus.paymentVerified:
      case RedeemStatus.processing:
      case RedeemStatus.processingComplete:
        return RedeemStepVisual.paymentVerified;
      case RedeemStatus.shipped:
      case RedeemStatus.delivered:
      case RedeemStatus.completed:
        return RedeemStepVisual.shipped;
      default:
        return null;
    }
  }

  void onPayTokenChange() {
    isPaymentWithTokenBlocked.value = true;
    final token = selectedTokenFrom.value;
    final quote = r.value;

    if (token == null || quote?.quoteAmount == null) return;

    final double? currentRate = (token.asset_info?.rateChange?.currentRate
        ?.toDouble());
    if (currentRate == null || currentRate <= 0) {
      DynamicToast.error(
        title: 'redeem.detail_controller.quote_error_title'.tr,
        description: 'redeem.detail_controller.quote_error_description'
            .trParams({'tokenName': token.asset_info?.name ?? 'el token'.tr}),
      );
      return;
    }

    final double availableBalance = (token.available?.toDouble()) ?? 0.0;
    final double? requiredAmount = quote?.quoteAmount!;
    final double availableValueInQuoteCurrency = availableBalance * currentRate;
    final quoteCurrencyCode = quote?.quoteCurrency?.code ?? 'USD';

    logger.log(
      label: 'onPayTokenChange',
      content:
          'Valor del Saldo: ${availableValueInQuoteCurrency.toStringAsFixed(2)} $quoteCurrencyCode. Requerido: ${requiredAmount?.toHauvNumericString(decimals: 2)} $quoteCurrencyCode',
    );

    if (availableValueInQuoteCurrency >= requiredAmount!) {
      isPaymentWithTokenBlocked.value = false;
    } else {
      DynamicToast.error(
        title: 'redeem.detail_controller.insufficient_balance_title'.tr,
        description: 'redeem.detail_controller.insufficient_balance_description'
            .trParams({'tokenName': token.asset_info?.name ?? ''}),
      );
      isPaymentWithTokenBlocked.value = true;
    }
  }

  Widget buildStepContent(RedeemStepVisual visualStep) {
    final currentRealStatus = r.value?.status;
    switch (visualStep) {
      case RedeemStepVisual.pendingQuote:
        return Text(
          'redeem.detail_controller.step_content_pending_quote'.tr,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
        );
      case RedeemStepVisual.paymentPending:
        return Obx(() {
          final bool canPerformPaymentAction =
              currentRealStatus == RedeemStatus.quoted ||
              currentRealStatus == RedeemStatus.accepted;
          String textContent = canPerformPaymentAction
              ? 'redeem.detail_controller.step_content_payment_pending_action'
                    .trParams({
                      'amount':
                          r.value?.quoteAmount?.toString().toHauvNumericString(
                            decimals: 2,
                          ) ??
                          '0.00',
                      'currency': r.value?.quoteCurrency?.code ?? 'USD',
                    })
              : 'redeem.detail_controller.step_content_payment_pending_verification'
                    .tr;

          if (showPaymentForm.value && canPerformPaymentAction) {
            return DynamicForm(
              formKey: paymentMethodFormKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: Column(
                children: [
                  Text(
                    'redeem.detail_controller.step_content_payment_form_total'
                        .trParams({
                          'amount':
                              r.value?.quoteAmount
                                  ?.toString()
                                  .toHauvNumericString(decimals: 2) ??
                              '0.00',
                          'currency': r.value?.quoteCurrency?.code ?? 'USD',
                        }),
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.dark2,
                    ),
                  ),
                  const DynamicDivider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: DynamicCheckbox(
                            text:
                                'redeem.detail_controller.pay_with_tokens_checkbox'
                                    .tr,
                            value: payWithTokens.value,
                            onChanged: (_) async {
                              showLoading();
                              payWithTokens.value = !payWithTokens.value;

                              if (!payWithTokens.value) {
                                tokens.clear();
                                selectedTokenFrom.value = null;
                                isPaymentWithTokenBlocked.value = true;
                                dismissLoading();
                                return;
                              }

                              await walletController.chargeAllBalances();

                              tokens.value = walletController.tokens;

                              dismissLoading();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const DynamicDivider(height: 20),
                  Obx(() {
                    if (payWithTokens.value) {
                      return Column(
                        children: [
                          DynamicDropdownInput<AssetBalance>(
                            label:
                                'redeem.detail_controller.payment_token_label'
                                    .tr,
                            items: tokens
                                .map(
                                  (t) => DropdownItem<AssetBalance>(
                                    value: t,
                                    label: t.asset_info!.name ?? '',
                                    icon: buildAssetImage(
                                      t.asset_info!.asset_image_url ?? '',
                                    ),
                                  ),
                                )
                                .toList(),
                            value: selectedTokenFrom.value,
                            onChanged: (asset) {
                              if (asset != null) {
                                selectedTokenFrom.value = asset;
                                onPayTokenChange();
                              }
                            },
                            labelStyle: textTheme.displaySmall?.copyWith(
                              height: 1.5,
                            ),
                            dropdownSearchInputType: TextInputType.text,
                            showIcons: true,
                          ),
                          const DynamicDivider(height: 20),
                          Obx(
                            () => DynamicButton(
                              onPressed: isPaymentWithTokenBlocked.value
                                  ? null
                                  : _submitPaymentProof,
                              baseColor: AppColors.main,
                              child: Text(
                                'redeem.detail_controller.confirm_payment_button'
                                    .tr,
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.light,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          DynamicDropdownInput(
                            label:
                                'redeem.detail_controller.available_payment_methods_label'
                                    .tr,
                            items: availablePaymentMethods
                                .map(
                                  (p) =>
                                      DropdownItem(value: p.id, label: p.name),
                                )
                                .toList(),
                            value: '',
                            onChanged: (id) => getPaymentMethodDetails(id!),
                            labelStyle: textTheme.displaySmall?.copyWith(
                              height: 1.5,
                            ),
                            validator: Validations.validationDropdown,
                            leading: GestureDetector(
                              onTap: () => DynamicShowPaymentMethodInfo(
                                paymentMethods: availablePaymentMethodsDetail,
                                title:
                                    'redeem.detail_controller.available_methods_title'
                                        .tr,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                child: Icon(
                                  Icons.info_outline,
                                  color: AppColors.main2,
                                  size: 30,
                                ),
                              ),
                            ),
                            dropdownSearchInputType: TextInputType.text,
                          ),
                          const DynamicDivider(height: 24),
                          DynamicImagePickerInput(
                            label:
                                'redeem.detail_controller.payment_proof_label'
                                    .tr,
                            controller: proofImageController,
                          ),
                          const DynamicDivider(height: 20),
                          DynamicInput(
                            label:
                                'redeem.detail_controller.payment_reference_label'
                                    .tr,
                            controller: proofController,
                            validationPatter: (v) =>
                                Validations.validationInputText(
                                  v,
                                  minLength: 5,
                                  maxLength: 20,
                                  additionalAllowedChars: ['-'],
                                ),
                            inputType: TextInputType.text,
                          ),
                          const DynamicDivider(height: 20),
                          DynamicButton(
                            baseColor: AppColors.main,
                            onPressed: validatePaymentForm,
                            child: Text(
                              'redeem.detail_controller.send_proof_button'.tr,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.light,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textContent,
                  style: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
                ),
                if (canPerformPaymentAction) ...[
                  const DynamicDivider(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DynamicButton(
                          baseColor: AppColors.transparent,
                          borderColor: AppColors.failure,
                          onPressed: cancelRedeem,
                          child: Text(
                            'redeem.detail_controller.cancel_button'.tr,
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.failure,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DynamicButton(
                          baseColor: AppColors.main,
                          onPressed: confirmPayment,
                          child: Text(
                            'redeem.detail_controller.accept_button'.tr,
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.light,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          }
        });
      case RedeemStepVisual.paymentVerified:
        return Text(
          'redeem.detail_controller.step_content_payment_verified'.tr,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
        );
      case RedeemStepVisual.shipped:
        return const SizedBox.shrink();
    }
  }

  String getSubtitleForStep(int index, int currentVisualStepIndex) {
    if (r.value == null) return '';
    if (index > currentVisualStepIndex) return '';
    if (index == 0) return r.value!.createdAt;
    if (index <= currentVisualStepIndex) return r.value!.updatedAt;
    return '';
  }

  getPaymentMethodDetails(String id) async {
    await _financialController.fetchPaymentMethodDetailsByPaymentMethod(id);
    availablePaymentMethodsDetail = _financialController.paymentMethodDetails;
  }
}
