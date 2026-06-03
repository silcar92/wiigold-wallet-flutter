import 'package:get/get.dart';
import 'package:wiigold/app/modules/card/controllers/card_controller.dart';

//? CONTROLLER

class CardBindins extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CardController>(() => CardController());
  }
}
