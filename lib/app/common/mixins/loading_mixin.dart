import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin LoadingMixin {
  final RxBool _isLoading = false.obs;
  final RxBool _showLoader = false.obs;

  RxBool get isLoading => _isLoading;
  RxBool get showLoader => _showLoader;

  void showLoading({BuildContext? context, bool showLoader = false}) {
    FocusManager.instance.primaryFocus?.unfocus();

    _showLoader.value = showLoader;
    _isLoading.value = true;
  }

  void dismissLoading({BuildContext? context}) {
    FocusManager.instance.primaryFocus?.unfocus();

    _showLoader.value = false;
    _isLoading.value = false;
  }
}
