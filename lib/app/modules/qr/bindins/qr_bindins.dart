import 'package:get/get.dart';
import 'package:wiigold/app/modules/qr/controllers/qr_controller.dart';

//? CONTROLLER

class QrBindins extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrController>(() => QrController());
  }
}
