import 'package:flutter/material.dart';
import 'package:wiigold/config/environment.dart';

//? THEME & IMAGES
import 'package:wiigold/theme/Colors.dart';

class CheckboxSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;

  const CheckboxSemantics({
    required this.identifier,
    this.semanticLabel,
    this.hint,
  });
}

class DynamicCheckbox extends StatelessWidget {
  final String? text;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool isDisabled;

  final TextStyle? textStyle;
  final Color? activeColor;
  final Color? checkColor;
  final WidgetStateProperty<Color?>? fillColor;
  final MaterialTapTargetSize? tapTargetSize;

  final CheckboxSemantics? semanticSettings;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;

  const DynamicCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.text,
    this.isDisabled = false,
    this.textStyle,
    this.activeColor,
    this.checkColor,
    this.fillColor,
    this.tapTargetSize,
    this.semanticSettings,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget checkboxWidget = Checkbox(
      value: value,
      onChanged: isDisabled ? null : onChanged,
      activeColor: activeColor ?? AppColors.main,
      checkColor: checkColor ?? AppColors.light2,
      fillColor: fillColor,
      materialTapTargetSize: tapTargetSize,
    );

    Widget content = Row(
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: rowCrossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        checkboxWidget,
        if (text != null)
          Flexible(
            child: Text(
              text!,
              style:
                  textStyle ??
                  textTheme.bodyLarge?.copyWith(
                    color: isDisabled
                        ? AppColors.dark3
                        : (value ? AppColors.main : AppColors.dark),
                  ),
            ),
          ),
      ],
    );

    Widget tappableContent = GestureDetector(
      onTap: (isDisabled || onChanged == null)
          ? null
          : () {
              onChanged!(!value);
            },
      behavior: HitTestBehavior.opaque,
      child: content,
    );

    return _formatSemantic(tappableContent, context);
  }

  Widget _formatSemantic(Widget child, BuildContext context) {
    if (!EnvironmentConfig.inRenderSemantics || semanticSettings == null) {
      return child;
    }

    return Semantics(
      identifier: semanticSettings!.identifier,
      label: semanticSettings!.semanticLabel ?? text,
      hint: semanticSettings!.hint,
      checked: value,
      enabled: !isDisabled,
      toggled: value,
      onTap: (isDisabled || onChanged == null)
          ? null
          : () {
              onChanged!(!value);
            },
      child: child,
    );
  }
}
