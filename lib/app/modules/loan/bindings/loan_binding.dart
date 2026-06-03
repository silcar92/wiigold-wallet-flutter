import 'package:get/get.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/loan/controllers/loan_controller.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_request_controller.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_data_controller.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_detail_controller.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_payment_controller.dart';

class LoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanController>(() => LoanController());
    Get.lazyPut<LoanRequestController>(() => LoanRequestController());
    Get.lazyPut<LoanDataController>(() => LoanDataController());
    Get.lazyPut<LoanDetailController>(() => LoanDetailController());
    Get.put<LoanPaymentController>(LoanPaymentController(), permanent: true);
  }
}
