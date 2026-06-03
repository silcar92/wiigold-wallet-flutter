import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/theme/Colors.dart';

class PasswordConditionsWidget extends StatelessWidget {
  final TextEditingController controller;

  const PasswordConditionsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final text = value.text;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PasswordCondition(
              met: text.length >= 8,
              label: 'validation.pass_condition_min_length'.tr,
            ),
            _PasswordCondition(
              met: RegExp(r'[a-z]').hasMatch(text),
              label: 'validation.pass_condition_lowercase'.tr,
            ),
            _PasswordCondition(
              met: RegExp(r'[A-Z]').hasMatch(text),
              label: 'validation.pass_condition_uppercase'.tr,
            ),
            _PasswordCondition(
              met: RegExp(r'[0-9]').hasMatch(text),
              label: 'validation.pass_condition_numbers'.tr,
            ),
            _PasswordCondition(
              met: RegExp(r'[!@#$%^&*()\[\]{}<>,.?":;_\-+=/\\|~`]').hasMatch(text),
              label: 'validation.pass_condition_special'.tr,
            ),
          ],
        );
      },
    );
  }
}

class _PasswordCondition extends StatelessWidget {
  final bool met;
  final String label;

  const _PasswordCondition({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = met ? AppColors.success : AppColors.dark2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
