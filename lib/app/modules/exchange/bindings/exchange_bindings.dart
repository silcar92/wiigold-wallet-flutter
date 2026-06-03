import 'package:get/get.dart';

//? Controller
import 'package:wiigold/app/modules/exchange/controllers/exchange_controller.dart';

class ExchangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExchangeController>(() => ExchangeController());
  }
}
