import 'package:get/get.dart';

//? Controller
import 'package:wiigold/app/modules/register/controllers/register_controller.dart';
import 'package:wiigold/app/modules/register/controllers/register_verification_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<RegisterVerificationController>(
      () => RegisterVerificationController(),
    );
  }
}
