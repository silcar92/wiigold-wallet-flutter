import 'package:flutter/material.dart';
import 'package:wiigold/config/environment.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? CONST
import 'package:wiigold/theme/Responsive.dart';

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

class DynamicButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  final Color borderColor;
  final Color baseColor;
  final Color disabledColor;

  final bool isDisabled;
  final bool isGradient;

  final ButtonSemantics? semanticSettings;

  const DynamicButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.isGradient = false,
    this.radius,
    this.isDisabled = false,
    this.borderColor = Colors.transparent,
    this.baseColor = AppColors.main,
    this.disabledColor = AppColors.main2,
    this.semanticSettings,
  });

  @override
  Widget build(BuildContext context) {
    double scaleFactor = AppResponsive.calculateScaleFactor(context);

    return SizedBox(
      width: width,
      height: height ?? (57 * scaleFactor),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 100.0),
          gradient: !isDisabled && isGradient
              ? LinearGradient(
                  colors: [baseColor.withAlpha(200), baseColor],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: !isGradient ? baseColor : null,
        ),
        child: _formatSemantic(
          ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              backgroundColor: Colors.transparent,
              foregroundColor: !isDisabled ? baseColor : disabledColor,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 100.0),
                side: BorderSide(color: borderColor),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
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
      child: child,
    );
  }
}
