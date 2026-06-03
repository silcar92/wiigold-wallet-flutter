import 'package:get/get.dart';
import 'package:wiigold/app/modules/token/controllers/token_controller.dart';

//? Controller

class TokenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenController>(() => TokenController());
  }
}
