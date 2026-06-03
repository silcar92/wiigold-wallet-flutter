import 'package:get/get.dart';
import 'package:wiigold/app/modules/security/controllers/security_controller.dart';

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityController>(() => SecurityController());
  }
}
