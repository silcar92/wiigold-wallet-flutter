import 'package:get/get.dart';

//? Controller
import 'package:wiigold/app/modules/recovery/controllers/recovery_controller.dart';

class RecoveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoveryController>(() => RecoveryController());
  }
}
