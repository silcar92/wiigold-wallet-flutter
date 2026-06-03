import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/app/data/models/entities/payment_methods_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/services/biometric_service.dart';
import 'package:wiigold/app/modules/loan/repositories/loan_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? REPOSITORIES

//? MIXINS

//? THEME & IMAGES

//? WIDGETS

class LoanPaymentController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "LoanPaymentController");

  final LoanRepository _loanRepository = LoanRepository();
  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  final BiometricService _biometricService = Get.find<BiometricService>();

  RxBool inAmountForm = true.obs;

  final FinancialController _financialController = Get.find();

  final RxString selectedPaymentMethodId = RxString('');

  RxList<PaymentMethodType> get availablePaymentMethods =>
      _financialController.paymentMethods;
  late RxList<PaymentMethod> availablePaymentMethodsDetail =
      <PaymentMethod>[].obs;

  RxString loanReference = ''.obs;

  final paymentAmountFormKey = GlobalKey<FormState>();
  final paymentMethodFormKey = GlobalKey<FormState>();

  RxDouble remainingAmount = 0.0.obs;
  final TextEditingController amountController = TextEditingController(
    text: "",
  );

  final ValueNotifier<String?> proofImageController = ValueNotifier(null);

  final TextEditingController paymentDateController = TextEditingController(
    text: "",
  );

  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController proofController = TextEditingController(text: "");

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    proofController.dispose();
  }

  handleInitialParams() {
    final params = Get.parameters;

    if (params['data'] != null) {
      final String jsonDataString = params['data']!;
      final dynamic data = jsonDecode(jsonDataString);

      logger.log(
        label: "jsonDecode(jsonDataString)",
        customData: jsonDecode(jsonDataString),
      );

      _initializePaymentMethods();

      if (data['amount'] != null) {
        amountController.text = "0";
        remainingAmount.value = data['amount'].toString().toDouble();
      }

      if (data['loan_reference'] != null) {
        loanReference.value = data['loan_reference'].toString();
      }
    }
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
        reason: 'Error al obtener datos desde FinancialController.',
      );
    }
  }

  void validatePaymentAmountForm() async {
    if (!paymentAmountFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    Get.toNamed(AppRoutes.LOAN_PAYMENT_INFO);
  }

  setAllAmount() {
    amountController.text = remainingAmount.value.toHauvNumericString();
  }

  void validatePaymentMethodForm() async {
    showLoading(context: Get.context!, showLoader: true);

    if (!paymentMethodFormKey.currentState!.validate()) {
      dismissLoading();

      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return;
    }

    _submitLoanPaymentForm();
  }

  _submitLoanPaymentForm() async {
    final isAuthenticated = await _biometricService.authenticate(
      reason: 'loan.payment_controller.biometric_reason'.tr,
    );

    if (!isAuthenticated) {
      DynamicToast.error(
        title: 'loan.payment_controller.biometric_cancelled_title'.tr,

        description:
            'loan.payment_controller.biometric_cancelled_description'.tr,
      );

      dismissLoading();

      return;
    }

    try {
      ResponseApi res = await _loanRepository.setLoanPayment({
        "loan_reference": loanReference.value,
        "amount_usd": amountController.text.toDouble(),
        "payment_reference": proofController.text,
        "payment_date": paymentDateController.text,
        "email_user": emailController.text,
        "proof_payment": proofImageController.value,
      });

      if (res.status == 'error') {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'form.invalidForm_error'.trParams({
            'message': res.message.toString(),
          }),
        );

        return;
      }

      DynamicToast.success(
        title: 'loan.payment_controller.payment_successful'.tr,
      );

      dismissLoading();

      Get.offAllNamed(
        AppRoutes.LOAN_DETAIL,
        parameters: {
          "data": jsonEncode({"loan_reference": loanReference.value}),
        },
      );
    } catch (e) {
      print('e: ${e.toString()}');
    } finally {
      dismissLoading();
    }
  }

  void updateSelectedPaymentMethod(String value) {
    selectedPaymentMethodId.value = value;

    update();
  }

  getPaymentMethodDetails(String id) async {
    updateSelectedPaymentMethod(id);

    await _financialController.fetchPaymentMethodDetailsByPaymentMethod(id);

    availablePaymentMethodsDetail = _financialController.paymentMethodDetails;
  }
}
