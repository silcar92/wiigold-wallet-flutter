import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicTermsLinks extends StatelessWidget {
  final RxBool value;
  final String prefixKey;
  final String linkKey;
  final String? suffixKey;
  final VoidCallback? onLinkTap;

  const DynamicTermsLinks({
    Key? key,
    required this.value,
    required this.prefixKey,
    required this.linkKey,
    this.suffixKey,
    this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FinancialController financialController =
        Get.find<FinancialController>();
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => Checkbox(
            value: value.value,
            onChanged: (newValue) => value.value = newValue ?? false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
        ),

        const SizedBox(width: 4),

        RichText(
          text: TextSpan(
            style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            children: [
              TextSpan(
                text: prefixKey.tr,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => value.toggle(),
              ),

              TextSpan(
                text: linkKey.tr,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.dark,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (onLinkTap != null) {
                      onLinkTap!();
                    } else {
                      financialController.openTermsAndConditions();
                    }
                  },
              ),

              if (suffixKey != null)
                TextSpan(
                  text: suffixKey!.tr,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => value.toggle(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
