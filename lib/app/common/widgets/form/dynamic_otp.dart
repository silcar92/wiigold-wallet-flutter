import 'package:flutter/material.dart';
import 'package:wiigold/config/environment.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/theme/Responsive.dart';

//? PIN
import 'package:pinput/pinput.dart';

class OtpSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;
  final String? errorMessage;

  const OtpSemantics({
    required this.identifier,
    this.semanticLabel,
    this.hint,
    this.errorMessage,
  });
}

class DynamicOtp extends StatelessWidget {
  final dynamic controller;
  final dynamic validationPatter;
  final bool isDisabled;

  final void Function(String)? onTapEnter;

  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final InputDecoration? inputDecoration;

  final OtpSemantics? semanticSettings;

  const DynamicOtp({
    super.key,
    required this.controller,
    this.validationPatter,
    this.isDisabled = false,
    this.onTapEnter,
    this.labelStyle,
    this.inputStyle,
    this.inputDecoration,
    this.semanticSettings,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final double scaleFactor = AppResponsive.calculateScaleFactor(context);

    final defaultPinTheme = PinTheme(
      width: 70,
      height: 80 * (scaleFactor),
      textStyle: const TextStyle(fontSize: 22, color: AppColors.light),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.dark),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formatSemantic(
          Pinput(
            autofocus: true,
            length: 6,
            controller: controller,
            defaultPinTheme: defaultPinTheme,
            obscureText: false,
            separatorBuilder: (index) => const SizedBox(width: 4),
            validator: validationPatter,
            onSubmitted: onTapEnter,
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 1,
                  color: AppColors.main,
                ),
              ],
            ),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.main),
              ),
            ),
            errorTextStyle: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.failure,
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: AppColors.main,
                border: Border.all(color: AppColors.main),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyBorderWith(
              border: Border.all(color: AppColors.failure),
            ),
            onCompleted: onTapEnter,
          ),
        ),
      ],
    );
  }

  Widget _formatSemantic(Widget child) {
    if (!EnvironmentConfig.inRenderSemantics || semanticSettings == null) {
      return child;
    }
    return semanticSettings != null
        ? Semantics(
            textField: true,
            label: semanticSettings!.semanticLabel,
            hint: semanticSettings!.hint,
            value: controller.text.isNotEmpty
                ? controller.text
                : semanticSettings?.hint ?? '',
            identifier: semanticSettings!.identifier,
            child: child,
          )
        : child;
  }
}
