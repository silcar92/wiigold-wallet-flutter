import 'package:get/get.dart';

//? CONTROLLERS
import 'package:wiigold/app/modules/request/controllers/request_controller.dart';

class RequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestController>(() => RequestController());
  }
}
