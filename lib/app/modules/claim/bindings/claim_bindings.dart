import 'package:get/get.dart';
import 'package:wiigold/app/modules/claim/controllers/claim_controller.dart';

//? Controller
import 'package:wiigold/app/modules/login/controllers/login_controller.dart';

class ClaimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClaimController>(() => ClaimController());
  }
}
