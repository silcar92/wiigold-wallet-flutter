import 'package:flutter/material.dart';

//? THEME & IMAGES

//? WIDGETS
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/config/environment.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicClipboardInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validationPatter;
  final bool isDisabled;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final InputDecoration? inputDecoration;
  final Widget? leading;
  final Widget? trailing;
  final InputSemantics? semanticSettings;
  final ValueChanged<String>? onTapEnter;
  final VoidCallback clipboardAction;
  final String clipboardButtonText;

  DynamicClipboardInput({
    super.key,
    required this.label,
    required this.controller,
    required this.clipboardAction,
    required this.clipboardButtonText,
    this.validationPatter,
    this.isDisabled = false,
    this.labelStyle,
    this.inputStyle,
    this.onTapEnter,
    this.inputDecoration,
    this.leading,
    this.trailing,
    this.semanticSettings,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: _formatSemantic(
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: AppColors.dark3, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: DynamicInput(
                        controller: controller,
                        inputType: TextInputType.text,
                        inputStyle:
                            inputStyle ??
                            textTheme.titleMedium?.copyWith(
                              color: AppColors.dark3,
                              fontWeight: FontWeight.w600,
                            ),
                        inputDecoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                        validationPatter: validationPatter,
                        isDisabled: isDisabled,
                        onTapEnter: onTapEnter,
                      ),
                    ),

                    DynamicButton(
                      width: 78,
                      height: 30,
                      baseColor: AppColors.accent,
                      radius: 50,
                      onPressed: clipboardAction,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        spacing: 2,
                        children: [
                          Icon(Icons.copy, size: 14, color: AppColors.dark),
                          Text(
                            clipboardButtonText,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formatSemantic(Widget child) {
    if (!EnvironmentConfig.inRenderSemantics || semanticSettings == null) {
      return child;
    }

    return Semantics(
      textField: true,
      label: semanticSettings!.semanticLabel ?? label,
      hint: semanticSettings!.hint,
      value: controller.text.isNotEmpty
          ? controller.text
          : semanticSettings?.hint ?? '',
      identifier: semanticSettings!.identifier,
      child: child,
    );
  }
}
