import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/banks.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/data/models/request/loan_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/services/biometric_service.dart';
import 'package:wiigold/app/modules/loan/repositories/loan_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? MIXINS

//? WIDGETS

//? Others

class LoanDataController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "LoanController");

  final LoanRepository _loanRepository = LoanRepository();

  final BiometricService _biometricService = Get.find<BiometricService>();

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  LoanData loan = LoanData();

  final TextEditingController accountNameController = TextEditingController(
    text: "",
  );

  final TextEditingController accountNumberController = TextEditingController(
    text: '',
  );

  final TextEditingController bankNameController = TextEditingController(
    text: '',
  );

  final RxString bankName = ''.obs;

  final TextEditingController swiftCodeController = TextEditingController(
    text: '',
  );

  final RxString selectedTermId = RxString('');
  RxList<LoanTerm> loanterms = <LoanTerm>[].obs;

  final TextEditingController termController = TextEditingController(text: '');

  final loanDataFormKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();

    _handleInitialParams();
    chargeData();
  }

  _handleInitialParams() {
    final params = Get.parameters;

    if (params['data'] != null) {
      final String jsonDataString = params['data']!;
      final dynamic data = jsonDecode(jsonDataString);

      loan = loan.copyWith(
        codeAsset: data['code_asset'],
        amountUsd: data['amount_usd'],
      );
    }
  }

  Future<void> chargeData() async {
    chargeLoanTerms();
  }

  Future<void> chargeLoanTerms() async {
    showLoading(context: Get.context!);

    try {
      ResponseApi res = await _loanRepository.getTerms();

      if (res.status == 'success') {
        final data = res.data;
        final List<dynamic> rawDataList = data['terms'] as List<dynamic>;

        final List<LoanTerm> loadedLoanTerms = rawDataList
            .whereType<Map<String, dynamic>>()
            .map((jsonMap) {
              try {
                return LoanTerm.fromJson(jsonMap);
              } catch (e) {
                return null;
              }
            })
            .whereType<LoanTerm>()
            .toList();

        loadedLoanTerms.sort((a, b) => a.interestRate.compareTo(b.interestRate));

        logger.log(label: "loadedLoanTerms", content: loadedLoanTerms.toString());

        loanterms.value = loadedLoanTerms;
      }
    } catch (e) {
      loanterms.value = [];

      print("e: ${e.toString()}");
    } finally {
      dismissLoading();
    }
  }

  Future<void> validateLoanDataForm() async {
    showLoading(context: Get.context!, showLoader: true);

    if (!loanDataFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      dismissLoading();

      return;
    }

    if (bankName.value == '') {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'loan.data_controller.invalid_swift_code'.tr,
      );

      dismissLoading();

      return;
    }

    _submitLoanDataForm();
  }

  void _submitLoanDataForm() async {
    final isAuthenticated = await _biometricService.authenticate(
      reason: 'loan.data_controller.biometric_reason'.tr,
    );

    if (!isAuthenticated) {
      DynamicToast.error(
        title: 'loan.data_controller.biometric_cancelled_title'.tr,
        description: 'loan.data_controller.biometric_cancelled_description'.tr,
      );

      dismissLoading();

      return;
    }

    try {
      loan = loan.copyWith(uuidTermDays: selectedTermId.value);

      ResponseApi res = await _loanRepository.setLoan(loan.toJson());

      dismissLoading();

      if (res.status == 'error') {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'form.invalidForm_error'.trParams({
            'message': res.message.toString(),
          }),
        );

        return;
      }

      Get.offAllNamed(AppRoutes.LOAN_FINISH);
    } catch (e) {
      print("e: ${e}");

      dismissLoading();
    }
  }

  //? loan - loan data form
  void updateSelectedTerm(String value) {
    selectedTermId.value = value;

    update();
  }

  changeSwiftCode(String value) {
    value = value.trim();

    if (getBankBySwiftCode(value) != null) {
      bankName.value = getBankBySwiftCode(value.trim())!.bankName;

      bankNameController.text = bankName.value;
    } else {
      bankName.value = '';
      bankNameController.text = '';
    }
  }
}
