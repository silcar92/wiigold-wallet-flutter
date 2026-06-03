import 'package:get/get.dart';
import 'package:wiigold/app/modules/sell/controllers/sell_controller.dart';

//? Controller

class SellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellController>(() => SellController());
  }
}
