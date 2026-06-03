import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_otp.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

/// Checks if 2FA is configured. If not, shows a toast and redirects to setup.
Future<bool> require2FAOrRedirect() async {
  final api = ApiProvider();
  final response = await api.genericGet(ApiEndpoints.totp_setup);
  if (response.status == 'success' && response.data?['is_2fa_enabled'] == true) {
    return true;
  }
  DynamicToast.error(
    title: 'Autenticación de dos factores no configurada',
    description: 'Configúrala antes de realizar transacciones.',
  );
  await Future.delayed(const Duration(milliseconds: 600));
  Get.toNamed(AppRoutes.SECURITY_2FA);
  return false;
}

/// Shows a bottom sheet asking for a TOTP code before executing a transaction.
/// Calls [onConfirmed] only when the backend validates the code.
Future<void> showTotpConfirmDialog({
  required BuildContext context,
  required Future<void> Function() onConfirmed,
}) async {
  final TextEditingController codeController = TextEditingController();
  final RxBool isLoading = false.obs;

  await Get.bottomSheet(
    isScrollControlled: true,
    backgroundColor: AppColors.appBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    _TotpBottomSheetContent(
      codeController: codeController,
      isLoading: isLoading,
      onConfirmed: onConfirmed,
    ),
  );

  codeController.dispose();
}

class _TotpBottomSheetContent extends StatelessWidget {
  final TextEditingController codeController;
  final RxBool isLoading;
  final Future<void> Function() onConfirmed;

  const _TotpBottomSheetContent({
    required this.codeController,
    required this.isLoading,
    required this.onConfirmed,
  });

  Future<void> _verify() async {
    final code = codeController.text.trim();
    if (code.length != 6 || !RegExp(r'^\d{6}$').hasMatch(code)) {
      DynamicToast.error(title: 'security.totp_code_invalid'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final api = ApiProvider();
      final response = await api.genericPost(ApiEndpoints.totp_verify, {'totp_code': code});
      if (response.status == 'success') {
        Get.back();
        await onConfirmed();
      } else {
        DynamicToast.error(title: response.message.isNotEmpty ? response.message : 'security.totp_code_invalid'.tr);
      }
    } catch (_) {
      DynamicToast.error(title: 'security.error_generic'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dark3,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Icon(Icons.security, color: AppColors.accent, size: 40),
          Text(
            'security.totp_dialog.title'.tr,
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            'security.totp_dialog.subtitle'.tr,
            style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            textAlign: TextAlign.center,
          ),
          Center(child: DynamicOtp(controller: codeController)),
          Obx(() => DynamicButton(
            width: double.infinity,
            onPressed: isLoading.value ? null : _verify,
            child: isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: AppColors.light, strokeWidth: 2),
                  )
                : Text(
                    'security.totp_dialog.confirm_button'.tr,
                    style: textTheme.labelLarge?.copyWith(color: AppColors.light),
                  ),
          )),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'security.totp_dialog.cancel_button'.tr,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            ),
          ),
        ],
      ),
    );
  }
}
