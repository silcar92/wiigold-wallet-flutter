import 'package:get/get.dart';

//? CONTROLLERS
import 'package:wiigold/app/core/services/splash/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
