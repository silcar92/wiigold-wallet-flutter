import 'package:flutter/material.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/theme/Colors.dart';

//? THEME & IMAGES

class AmountChangeInput {
  final String label;
  final String currency;
  final String value;
  final String? semanticIdentifier;

  AmountChangeInput({
    required this.label,
    required this.currency,
    required this.value,
    this.semanticIdentifier,
  });
}

// ignore: must_be_immutable
class DynamicAmountChanger extends StatelessWidget
    implements PreferredSizeWidget {
  AmountChangeInput inputFrom;
  AmountChangeInput inputTo;
  Widget? extra;

  DynamicAmountChanger({
    super.key,
    required this.inputFrom,
    required this.inputTo,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Flex(
      direction: Axis.vertical,
      children: [
        DynamicNumeric(
          semanticSettings: inputFrom.semanticIdentifier != null
              ? NumericSemantics(identifier: inputFrom.semanticIdentifier!)
              : null,
          label: inputFrom.label,
          labelStyle: textTheme.titleMedium?.copyWith(
            color: AppColors.dark2,
            fontWeight: FontWeight.w600,
            height: .25,
          ),
          controller: TextEditingController(text: inputFrom.value),
          allowDecimals: true,
          maxDecimals: 2,
          min: 0,
          inputStyle: textTheme.displayMedium,
          inputDecoration: InputDecoration(
            hintText: '',

            suffix: Text(inputFrom.currency, style: textTheme.displaySmall),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 6),
          ),
          isDisabled: true,
        ),

        Divider(color: AppColors.main),

        DynamicDivider(height: 10),

        DynamicNumeric(
          semanticSettings: inputTo.semanticIdentifier != null
              ? NumericSemantics(identifier: inputTo.semanticIdentifier!)
              : null,
          label: inputTo.label,
          labelStyle: textTheme.titleMedium?.copyWith(
            color: AppColors.dark2,
            fontWeight: FontWeight.w600,
            height: .25,
          ),
          controller: TextEditingController(text: inputTo.value),
          allowDecimals: true,
          maxDecimals: 2,
          min: 0,
          inputStyle: textTheme.displayMedium,
          inputDecoration: InputDecoration(
            hintText: '',
            suffix: Text(inputTo.currency, style: textTheme.displaySmall),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 6),
          ),
          isDisabled: true,
        ),

        if (extra != null) extra!,
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
