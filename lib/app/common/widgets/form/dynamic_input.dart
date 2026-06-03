import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

class InputSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;
  final String? errorMessage;

  const InputSemantics({
    required this.identifier,
    this.semanticLabel,
    this.hint,
    this.errorMessage,
  });
}

class DynamicInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final FormFieldValidator<String>? validationPatter;
  final bool isDisabled;
  final bool disableNumericFormatter;

  final bool? enableInteractiveSelection;

  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final InputDecoration? inputDecoration;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  final int minLines;
  final int maxLines;

  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onTapEnter;

  final TextInputAction? textInputAction;

  final Widget? leading;
  final Widget? trailing;
  final InputSemantics? semanticSettings;

  DynamicInput({
    super.key,
    this.label,
    required this.controller,
    required this.inputType,
    this.hint,
    this.minLines = 1,
    this.maxLines = 1,
    this.validationPatter,
    this.isDisabled = false,
    this.labelStyle,
    this.inputStyle,
    this.inputDecoration,
    this.disableNumericFormatter = false,
    this.leading,
    this.trailing,
    this.semanticSettings,
    this.autovalidateMode,
    this.enableInteractiveSelection = true,
    this.onChanged,
    this.maxLength,
    this.inputFormatters,
    this.onTapEnter,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final FocusNode focusNode = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
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
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: _formatSemantic(
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              style: inputStyle ?? textTheme.titleMedium,
              decoration: _buildInputDecoration(context, textTheme),
              keyboardType: inputType,
              onChanged: onChanged,
              minLines: minLines,
              maxLines: maxLines <= minLines ? minLines + 1 : maxLines,
              validator: validationPatter,
              enabled: !isDisabled,
              maxLength: maxLength,
              enableInteractiveSelection: enableInteractiveSelection,

              maxLengthEnforcement: maxLength != null
                  ? MaxLengthEnforcement.enforced
                  : null,
              buildCounter:
                  (
                    BuildContext context, {
                    required int currentLength,
                    required bool isFocused,
                    required int? maxLength,
                  }) => null,
              autovalidateMode:
                  autovalidateMode ?? AutovalidateMode.onUserInteraction,
              inputFormatters: inputFormatters,
              onFieldSubmitted:
                  onTapEnter ??
                  (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
              textInputAction: textInputAction,
            ),
            context,
          ),
          leading: leading,
          trailing: trailing,
        ),
      ],
    );
  }

  Widget _formatSemantic(TextFormField input, BuildContext context) {
    return semanticSettings != null
        ? Semantics(
            textField: true,
            label: semanticSettings!.semanticLabel ?? label,
            hint: semanticSettings!.hint ?? hint,
            value: controller.text.isNotEmpty
                ? controller.text
                : semanticSettings?.hint ?? hint ?? '',
            identifier: semanticSettings!.identifier,
            child: input,
          )
        : input;
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    TextTheme textTheme,
  ) {
    return inputDecoration ??
        InputDecoration(
          hintText: hint ?? "${label}..." ?? '',

          hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 10.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.failure),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.failure, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          errorStyle: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.failure,
          ),
        );
  }
}
