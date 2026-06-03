import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/modules/security/repositories/security_repository.dart';

class SecurityController extends GetxController with LoadingMixin {
  final SecurityRepository _repository = SecurityRepository();

  final RxString totpSecret = ''.obs;
  final RxString totpUri = ''.obs;
  final RxBool is2FAEnabled = false.obs;
  final RxBool secretVisible = false.obs;

  final TextEditingController totpCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadSetupData();
  }

  Future<void> loadSetupData() async {
    showLoading();
    try {
      final response = await _repository.setup2FA();
      if (response.status == 'success') {
        totpSecret.value = response.data?['secret'] ?? '';
        totpUri.value = response.data?['uri'] ?? '';
        is2FAEnabled.value = response.data?['is_2fa_enabled'] ?? false;
      } else {
        DynamicToast.error(title: response.message ?? 'security.error_loading'.tr);
      }
    } catch (e) {
      DynamicToast.error(title: 'security.error_loading'.tr);
    } finally {
      dismissLoading();
    }
  }

  Future<void> openInAuthenticatorApp() async {
    if (totpUri.value.isEmpty) return;
    final uri = Uri.parse(totpUri.value);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      DynamicToast.info(title: 'security.totp_open_app_error'.tr);
    }
  }

  void copySecret() {
    if (totpSecret.value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: totpSecret.value));
    DynamicToast.success(title: 'security.totp_secret_copied'.tr);
  }

  void toggleSecretVisibility() {
    secretVisible.value = !secretVisible.value;
  }

  Future<void> activateTOTP() async {
    final code = totpCodeController.text.trim();
    if (code.length != 6 || !RegExp(r'^\d{6}$').hasMatch(code)) {
      DynamicToast.error(title: 'security.totp_code_invalid'.tr);
      return;
    }
    showLoading(showLoader: true);
    try {
      final response = await _repository.verifySetup2FA(code);
      if (response.status == 'success') {
        is2FAEnabled.value = true;
        totpCodeController.clear();
        DynamicToast.success(title: 'security.totp_activated'.tr);
        Get.back();
      } else {
        DynamicToast.error(title: response.message ?? 'security.totp_code_invalid'.tr);
      }
    } catch (e) {
      DynamicToast.error(title: 'security.error_generic'.tr);
    } finally {
      dismissLoading();
    }
  }

  Future<void> disableTOTP() async {
    final code = totpCodeController.text.trim();
    if (code.length != 6 || !RegExp(r'^\d{6}$').hasMatch(code)) {
      DynamicToast.error(title: 'security.totp_code_invalid'.tr);
      return;
    }
    showLoading(showLoader: true);
    try {
      final response = await _repository.disable2FA(code);
      if (response.status == 'success') {
        is2FAEnabled.value = false;
        totpSecret.value = '';
        totpUri.value = '';
        totpCodeController.clear();
        DynamicToast.success(title: 'security.totp_disabled'.tr);
        Get.back();
      } else {
        DynamicToast.error(title: response.message ?? 'security.totp_code_invalid'.tr);
      }
    } catch (e) {
      DynamicToast.error(title: 'security.error_generic'.tr);
    } finally {
      dismissLoading();
    }
  }

  @override
  void onClose() {
    totpCodeController.dispose();
    super.onClose();
  }
}
