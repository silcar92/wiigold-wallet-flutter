import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/modules/loan/repositories/loan_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';
//? MODELS

//? MIXINS

//? REPOSITORIES

//? THEME & IMAGES

class LoanController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "LoanController");

  final LoanRepository _loanRepository = LoanRepository();
  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  final RxList loans = [].obs;

  @override
  void onInit() async {
    super.onInit();

    await chargeData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> chargeData() async {
    getLoanList();
  }

  Future<void> getLoanList() async {
    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _loanRepository.loanList();

      if (res.status == 'success') {
        final data = res.data;

        if (data['has_active_loan'] == false) {
          loans.assignAll([]);
        } else {
          final loanList = data['loans'] as List;

          final processedLoans = loanList.map((loanData) {
            final loan = Map<String, dynamic>.from(loanData);

            loan['payment_progress'] = double.parse(
              (loan['payment_progress']).toStringAsFixed(2),
            );
            loan['payment_progress_aux'] = loan['payment_progress'] / 100;

            return loan;
          }).toList();

          loans.assignAll(processedLoans);
        }
      }
    } catch (e) {
      print("e: ${e.toString()}");
    } finally {
      dismissLoading();
    }
  }

  showDetail(String reference) {
    if (reference == null) return;

    Get.toNamed(
      AppRoutes.LOAN_DETAIL,
      parameters: {
        "data": jsonEncode({"loan_reference": reference}),
      },
    );
  }
}
