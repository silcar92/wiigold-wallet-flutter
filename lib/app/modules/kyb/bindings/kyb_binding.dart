import 'package:get/get.dart';
import 'package:wiigold/app/modules/kyb/controllers/kyb_controller.dart';

class KybBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KybController>(() => KybController(), fenix: true);
  }
}
