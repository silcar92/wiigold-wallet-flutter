import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/data/models/entities/payments_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/modules/loan/repositories/loan_repository.dart';

//? REPOSITORIES

//? MIXINS

class LoanDetailController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "LoanDetailController");

  final LoanRepository _loanRepository = LoanRepository();
  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  RxString loanReference = ''.obs;

  RxString loanAmount = ''.obs;
  RxString collateral = ''.obs;
  RxString paidAmount = ''.obs;
  RxString accruedInterest = ''.obs;
  RxDouble remainingAmount = 0.0.obs;
  RxString remainingAmountLabel = ''.obs;

  RxString interestRate = ''.obs;
  RxString dueDate = ''.obs;

  RxList<Payment> paymentList = <Payment>[].obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  handleParams() {
    final params = Get.parameters;

    if (params['data'] != null) {
      final data = jsonDecode(params['data']!);

      if (data['loan_reference'] != null) {
        loanReference.value = data['loan_reference'];

        chargeData();
      }
    }
  }

  Future<void> chargeData() async {
    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _loanRepository.loanDetail(
        loanReference.value,
      );

      if (res.status == 'success') {
        final data = res.data;

        final loan = data['loan'];
        chargeViewData(loan);

        final payments = data['payments'];
        chargePaymentsData(payments);
      }
    } catch (e) {
      print("e: ${e.toString()}");
    } finally {
      dismissLoading();
    }
  }

  chargeViewData(dynamic data) {
    loanAmount.value =
        '${data['loan_amount_usd'].toString().toHauvNumericString(decimals: 2)} USD';

    paidAmount.value =
        '${data['amount_paid'].toString().toHauvNumericString(decimals: 2)} USD';

    interestRate.value = '${data['interest_rate']} APY';

    accruedInterest.value =
        '${data['accrued_interest'].toString().toHauvNumericString(decimals: 2)} USD';

    dueDate.value =
        "${DateTime.tryParse(data['due_date'])?.toDateTimeFormat(showDate: true, showTime: true, formatAsHeader: true)} (-${data['days_remaining']} dias)";

    final auxCollateral = data['collateral'];

    collateral.value =
        '${auxCollateral['amount_locked'].toString().toHauvNumericString(decimals: 2)} ${auxCollateral['asset_name']}';

    final remainingAux = data['remaining_balance'].toString().toDouble() ?? 0.0;

    remainingAmountLabel.value =
        "${remainingAux.toString().toDouble().toHauvNumericString(decimals: 2)} USD";

    remainingAmount.value = remainingAux;
  }

  chargePaymentsData(dynamic data) {
    final List<Payment> payments = (data as List)
        .map((json) => Payment.fromJson(json as Map<String, dynamic>))
        .toList();

    paymentList.assignAll(payments);
  }
}
