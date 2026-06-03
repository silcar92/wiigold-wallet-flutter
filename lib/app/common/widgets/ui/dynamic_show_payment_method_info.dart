import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/data/models/entities/payment_methods_model.dart';
import 'package:wiigold/theme/Colors.dart';

Future<void> DynamicShowPaymentMethodInfo({
  required RxList<PaymentMethod> paymentMethods,
  String? title,
  String? closeButtonText,
}) {
  final effectiveTitle =
      title ?? 'widgets.dynamic_show_payment_method.default_title'.tr;
  final effectiveCloseButtonText =
      closeButtonText ?? 'widgets.dynamic_show_payment_method.close_button'.tr;

  return Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.light,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(effectiveTitle),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      content: SizedBox(
        width: double.maxFinite,
        child: Obx(() {
          if (paymentMethods.isEmpty) {
            return Center(
              child: Text(
                'widgets.dynamic_show_payment_method.no_methods_available'.tr,
                style: TextStyle(color: AppColors.dark),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: paymentMethods.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Divider(color: AppColors.dark3, thickness: 1.0),
            ),
            itemBuilder: (context, index) {
              final methodDetail = paymentMethods[index];

              return _PaymentMethodDetailItem(method: methodDetail);
            },
          );
        }),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            effectiveCloseButtonText,
            style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
              color: AppColors.main,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

class _PaymentMethodDetailItem extends StatelessWidget {
  final PaymentMethod method;

  const _PaymentMethodDetailItem({required this.method});

  bool _isValid(String? value) => value != null && value.isNotEmpty;

  String _generateClipboardText() {
    final buffer = StringBuffer();
    buffer.writeln('--- ${method.paymentMethodType.name} ---');

    if (_isValid(method.bank?.name))
      buffer.writeln(
        '${'widgets.dynamic_show_payment_method.bank_label'.tr}: ${method.bank!.name!}',
      );
    if (_isValid(method.accountName))
      buffer.writeln(
        '${'widgets.dynamic_show_payment_method.holder_label'.tr}: ${method.accountName!}',
      );
    if (_isValid(method.accountNumber))
      buffer.writeln(
        '${'widgets.dynamic_show_payment_method.account_number_label'.tr}: ${method.accountNumber!}',
      );
    if (_isValid(method.bank?.swiftCode))
      buffer.writeln(
        '${'widgets.dynamic_show_payment_method.swift_code_label'.tr}: ${method.bank!.swiftCode!}',
      );
    if (_isValid(method.currency?.code))
      buffer.writeln(
        '${'widgets.dynamic_show_payment_method.currency_label'.tr}: ${method.currency!.code!}',
      );
    if (_isValid(method.documentNumber))
      buffer.writeln(
        '${'widgets.dynamic_show_payment_method.document_label'.tr}: ${method.documentNumber!}',
      );
    if (_isValid(method.email))
      buffer.writeln(
        '${'widgets.dynamic_show_payment_method.email_label'.tr}: ${method.email!}',
      );

    return buffer.toString().trim();
  }

  void _copyAllDetailsToClipboard() {
    final String fullText = _generateClipboardText();
    if (fullText.isEmpty) return;

    try {
      Clipboard.setData(ClipboardData(text: fullText));
      DynamicToast.info(
        title: 'widgets.dynamic_show_payment_method.copied_success'.tr,
      );
    } catch (e) {
      DynamicToast.error(
        title: 'widgets.dynamic_show_payment_method.copy_error'.tr,
      );
    }
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: RichText(
        text: TextSpan(
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.dark,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.dark2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: _copyAllDetailsToClipboard,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              method.paymentMethodType.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 8),

            if (_isValid(method.bank?.name))
              _buildDetailRow(
                context,
                'widgets.dynamic_show_payment_method.bank_label'.tr,
                method.bank!.name!,
              ),

            if (_isValid(method.accountName))
              _buildDetailRow(
                context,
                'widgets.dynamic_show_payment_method.holder_label'.tr,
                method.accountName!,
              ),

            if (_isValid(method.accountNumber))
              _buildDetailRow(
                context,
                'widgets.dynamic_show_payment_method.account_number_label'.tr,
                method.accountNumber!,
              ),

            if (_isValid(method.bank?.swiftCode))
              _buildDetailRow(
                context,
                'widgets.dynamic_show_payment_method.swift_code_label'.tr,
                method.bank!.swiftCode!,
              ),

            if (_isValid(method.currency?.code))
              _buildDetailRow(
                context,
                'widgets.dynamic_show_payment_method.currency_label'.tr,
                method.currency!.code!,
              ),

            if (_isValid(method.documentNumber))
              _buildDetailRow(
                context,
                'widgets.dynamic_show_payment_method.document_label'.tr,
                method.documentNumber!,
              ),

            if (_isValid(method.email))
              _buildDetailRow(
                context,
                'widgets.dynamic_show_payment_method.email_label'.tr,
                method.email!,
              ),
          ],
        ),
      ),
    );
  }
}
