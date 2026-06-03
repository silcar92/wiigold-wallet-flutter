import 'package:get/get.dart';
import 'package:wiigold/app/core/services/transaction_detail/controllers/transaction_detail_controller.dart';

//? CONTROLLER

class TransactionDetailBindins extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionDetailController>(
      () => TransactionDetailController(),
    );
  }
}
