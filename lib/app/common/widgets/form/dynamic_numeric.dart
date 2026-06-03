import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:wiigold/config/environment.dart';
import 'package:wiigold/theme/Colors.dart';

class NumericInputFormatter extends TextInputFormatter {
  final double? max;

  NumericInputFormatter({this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String cleanText = newValue.text.replaceAll(RegExp(r'[\.,]'), '');

    if (max != null) {
      final int? currentValue = int.tryParse(cleanText);

      if (currentValue != null && currentValue > max!) {
        return oldValue;
      }
    }

    if (cleanText == newValue.text) {
      return newValue;
    }

    int cursorPosition = newValue.selection.end;
    final String textBeforeCursor = newValue.text.substring(0, cursorPosition);
    final int nonNumericCharsBeforeCursor = RegExp(
      r'[\.,]',
    ).allMatches(textBeforeCursor).length;

    final int newCursorPosition = cursorPosition - nonNumericCharsBeforeCursor;

    return TextEditingValue(
      text: cleanText,

      selection: TextSelection.collapsed(
        offset: newCursorPosition.clamp(0, cleanText.length),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final double? max;
  final int decimals;

  CurrencyInputFormatter({this.max, this.decimals = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newText = newValue.text;

    if (newText.endsWith('.') && !newText.contains(',')) {
      if (newText.split('.').length == 2) {
        newText = newText.replaceRange(newText.length - 1, null, ',');
      } else if (newText.split('.').length > 2) {
        newText = newText.substring(0, newText.length - 1) + ',';
      }
    }

    newText = newText.replaceAll(RegExp(r'[^\d,]'), '');

    if (newText.contains(',')) {
      final parts = newText.split(',');
      if (parts.length > 2) {
        newText = '${parts.first},${parts.sublist(1).join('')}';
      }
    }

    String integerPart = newText;
    String decimalPart = '';

    if (newText.contains(',')) {
      final parts = newText.split(',');
      integerPart = parts[0];
      decimalPart = parts[1];

      if (decimalPart.length > decimals) {
        decimalPart = decimalPart.substring(0, decimals);
        newText = '$integerPart,$decimalPart';
      }
    }

    if (max != null) {
      final cleanNumberText =
          '${integerPart.isEmpty ? '0' : integerPart.replaceAll('.', '')}'
          '${decimalPart.isNotEmpty ? '.$decimalPart' : ''}';

      final double? currentValue = double.tryParse(cleanNumberText);
      if (currentValue != null && currentValue > max!) {
        return oldValue;
      }
    }

    String formattedIntegerPart;
    if (integerPart.isEmpty) {
      formattedIntegerPart = '';
    } else {
      final cleanInteger = integerPart.replaceAll('.', '');
      if (cleanInteger.isEmpty) {
        formattedIntegerPart = '';
      } else {
        final number = int.tryParse(cleanInteger) ?? 0;
        final formatter = NumberFormat('#,###', 'es');
        formattedIntegerPart = formatter.format(number).replaceAll(',', '.');
      }
    }

    String formattedText;
    if (newText.contains(',')) {
      formattedText =
          '${integerPart.isEmpty ? '0' : formattedIntegerPart},$decimalPart';
    } else {
      formattedText = formattedIntegerPart;
    }

    int selectionIndex = newValue.selection.end;
    int separatorCount = '.'.allMatches(formattedText).length;
    int oldSeparatorCount = '.'.allMatches(oldValue.text).length;
    int separatorDelta = separatorCount - oldSeparatorCount;

    selectionIndex = (selectionIndex + separatorDelta).clamp(
      0,
      formattedText.length,
    );

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class NumericSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;
  final String? errorMessage;

  const NumericSemantics({
    required this.identifier,
    this.semanticLabel,
    this.hint,
    this.errorMessage,
  });
}

class DynamicNumeric extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final FormFieldValidator<String>? validationPatter;
  final bool isDisabled;

  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final InputDecoration? inputDecoration;

  final double? min;
  final double? max;

  final bool? allowDecimals;
  final int? maxDecimals;

  final bool? enableInteractiveSelection;
  final bool? disableNumericFormatter;

  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onTapEnter;

  final Widget? leading;
  final Widget? trailing;
  final NumericSemantics? semanticSettings;

  final FocusNode _focusNode = FocusNode();

  final Widget? sufix;
  final Widget? prefix;

  DynamicNumeric({
    super.key,
    this.label,
    required this.controller,
    this.hint,
    this.validationPatter,
    this.isDisabled = false,
    this.labelStyle,
    this.disableNumericFormatter = false,

    this.inputStyle,
    this.inputDecoration,
    this.leading,
    this.trailing,
    this.autovalidateMode,
    this.enableInteractiveSelection,
    this.onChanged,
    this.allowDecimals = true,
    this.onTapEnter,
    this.maxDecimals = 2,
    this.min,
    this.max,
    this.semanticSettings,
    this.sufix,
    this.prefix,
  });

  final GlobalKey<FormFieldState<String>> _formFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final int effectiveDecimals = (allowDecimals ?? true)
        ? (maxDecimals ?? 2)
        : 0;

    final List<TextInputFormatter> formatters = disableNumericFormatter == true
        ? [NumericInputFormatter(max: max)]
        : [CurrencyInputFormatter(max: max, decimals: effectiveDecimals)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && label!.isNotEmpty)
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
              enableInteractiveSelection: enableInteractiveSelection,
              key: _formFieldKey,
              controller: controller,
              focusNode: _focusNode,
              style: inputStyle ?? textTheme.titleSmall,
              decoration: _buildInputDecoration(context, textTheme),
              keyboardType: TextInputType.numberWithOptions(
                decimal: allowDecimals ?? true,
                signed: false,
              ),
              onChanged: onChanged,
              validator: validationPatter,
              enabled: !isDisabled,
              autovalidateMode:
                  autovalidateMode ?? AutovalidateMode.onUserInteraction,
              inputFormatters: formatters,
              onFieldSubmitted: onTapEnter,
            ),
          ),
          leading: leading,
          trailing: trailing,
        ),
      ],
    );
  }

  Widget _formatSemantic(TextFormField input) {
    if (!EnvironmentConfig.inRenderSemantics && semanticSettings == null) {
      return input;
    }

    return Semantics(
      textField: true,
      label: semanticSettings!.semanticLabel ?? label,
      hint: semanticSettings!.hint ?? hint,
      value: controller.text.isNotEmpty
          ? controller.text
          : (semanticSettings?.hint ?? hint ?? ''),
      identifier: semanticSettings!.identifier,
      child: input,
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    TextTheme textTheme,
  ) {
    final baseDecoration =
        inputDecoration ??
        InputDecoration(
          hintText: hint ?? "0,00",
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.failure),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.failure, width: 2.0),
          ),
          errorStyle: textTheme.bodyMedium?.copyWith(
            height: .75,
            fontWeight: FontWeight.w500,
            color: AppColors.failure,
          ),
        );

    return baseDecoration.copyWith(
      prefixIcon: baseDecoration.prefixIcon ?? prefix,
      suffixIcon: baseDecoration.suffixIcon ?? sufix,
    );
  }
}
