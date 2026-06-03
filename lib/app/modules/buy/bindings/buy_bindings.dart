import 'package:get/get.dart';

//? Controller
import 'package:wiigold/app/modules/buy/controllers/buy_controller.dart';

class BuyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BuyController>(BuyController(), permanent: true);
  }
}
