import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wiigold/config/environment.dart';
import 'package:wiigold/theme/Colors.dart';
import 'package:wiigold/theme/Responsive.dart';

//? THEME & IMAGES

//? CONST

class ButtonSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;
  final bool enabled;

  const ButtonSemantics({
    required this.identifier,
    this.semanticLabel,
    this.enabled = true,
    this.hint,
  });
}

class DynamicToggle extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  final double? width;
  final double? height;

  final bool isDisabled;

  final String? label;
  final TextStyle? labelStyle;

  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;

  final Color? disabledThumbColor;
  final Color? disabledTrackColor;

  final ButtonSemantics? semanticSettings;

  const DynamicToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.width,
    this.height,
    this.label,
    this.labelStyle,

    this.isDisabled = false,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.disabledThumbColor,
    this.disabledTrackColor,
    this.semanticSettings,
  });

  @override
  Widget build(BuildContext context) {
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    final TextTheme textTheme = Theme.of(context).textTheme;

    final WidgetStateProperty<Color?> effectiveThumbColor =
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledThumbColor ?? AppColors.dark;
          }

          if (states.contains(WidgetState.selected)) {
            return activeColor ?? AppColors.main;
          }

          return inactiveThumbColor ?? AppColors.dark;
        });

    final WidgetStateProperty<Color?> effectiveTrackColor =
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledTrackColor ?? AppColors.dark2.withAlpha(30);
          }

          if (states.contains(WidgetState.selected)) {
            return activeTrackColor ?? AppColors.main.withAlpha(100);
          }

          return inactiveTrackColor ?? AppColors.dark2;
        });

    Widget switchWidget = SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? (57 * scaleFactor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (label != null)
            Flexible(
              child: Text(
                label!,
                style:
                    labelStyle ??
                    textTheme.titleSmall?.copyWith(
                      color: AppColors.dark2,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          Switch(
            value: value,
            onChanged: isDisabled ? null : onChanged,
            thumbColor: effectiveThumbColor,
            trackColor: effectiveTrackColor,
          ),
        ],
      ),
    );

    return _formatSemantic(switchWidget);
  }

  Widget _formatSemantic(Widget child) {
    if (!EnvironmentConfig.inRenderSemantics || semanticSettings == null) {
      return child;
    }

    return Semantics(
      button: true,
      identifier: semanticSettings!.identifier,
      label: semanticSettings!.semanticLabel,
      hint: semanticSettings!.hint,
      enabled: semanticSettings!.enabled && !isDisabled,
      toggled: value,
      child: child,
    );
  }
}
