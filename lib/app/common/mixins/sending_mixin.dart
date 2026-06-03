import 'package:get/get.dart';

mixin sendingMixin {
  final RxBool _isSending = false.obs;

  RxBool get isSending => _isSending;

  void starSend() {
    isSending.value = true;
  }

  void finishSend() {
    isSending.value = false;
  }
}
