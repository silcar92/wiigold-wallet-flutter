import 'package:get/get.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/redeem/controllers/redeem_controller.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_request_controller.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_data_controller.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_detail_controller.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_payment_controller.dart';

class RedeemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RedeemController>(() => RedeemController());
    Get.lazyPut<RedeemRequestController>(() => RedeemRequestController());
    Get.lazyPut<RedeemDataController>(() => RedeemDataController());
    Get.lazyPut<RedeemDetailController>(() => RedeemDetailController());
    Get.lazyPut<RedeemPaymentController>(() => RedeemPaymentController());
  }
}
