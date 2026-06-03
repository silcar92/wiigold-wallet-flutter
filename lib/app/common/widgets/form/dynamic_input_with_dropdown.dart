import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/theme/Colors.dart';

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

class DynamicInputWithDropdown<T> extends StatefulWidget {
  final List<DropdownItem<T>> dropdownItems;
  final T? dropdownValue;
  final Function(T?) dropdownChange;
  final bool dropDisabled;
  final String searchHint;
  final TextInputType dropdownSearchInputType;
  final bool showIcons;
  final String? dropdownIdentifier;

  final FormFieldValidator<T?>? dropdownValidator;

  final TextEditingController inputController;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? inputChange;
  final bool enableInteractiveSelection;
  final int decimals;
  final double? max;
  final String? inputHint;
  final bool inputDisabled;

  final String? label;
  final bool isDisabled;
  final AutovalidateMode autovalidateMode;

  final ValueChanged<String>? onTapEnter;

  const DynamicInputWithDropdown({
    super.key,
    required this.dropdownItems,
    required this.dropdownValue,
    required this.dropdownChange,
    this.dropDisabled = false,
    this.searchHint = '...',
    required this.dropdownSearchInputType,
    this.showIcons = true,
    this.dropdownIdentifier,
    this.dropdownValidator,
    required this.inputController,
    this.validator,
    this.inputChange,
    this.enableInteractiveSelection = true,
    this.decimals = 2,
    this.inputHint,
    this.max,
    this.inputDisabled = false,
    this.label,
    this.isDisabled = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onTapEnter,
  });

  @override
  State<DynamicInputWithDropdown<T>> createState() =>
      _DynamicInputWithDropdownState<T>();
}

class _DynamicInputWithDropdownState<T>
    extends State<DynamicInputWithDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  String? _dropdownErrorText;

  @override
  void initState() {
    super.initState();

    _formatInitialValue();

    if (widget.autovalidateMode == AutovalidateMode.always) {
      _validateDropdown(widget.dropdownValue);
    }
  }

  void _formatInitialValue() {
    final initialText = widget.inputController.text;
    if (initialText.isEmpty) return;

    final formatter = CurrencyInputFormatter(
      max: widget.max,
      decimals: widget.decimals,
    );

    final formattedValue = formatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: initialText),
    );

    widget.inputController.value = formattedValue;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _handleDropdownChange(T? newValue) {
    widget.dropdownChange(newValue);
    if (widget.autovalidateMode != AutovalidateMode.disabled) {
      _validateDropdown(newValue);
    }
  }

  void _validateDropdown(T? value) {
    if (widget.dropdownValidator == null) return;
    setState(() {
      _dropdownErrorText = widget.dropdownValidator!(value);
    });
  }

  DropdownItem<T>? _findSelectedItem(T? currentValue) {
    if (currentValue == null) return null;
    try {
      return widget.dropdownItems.firstWhere(
        (item) => item.value == currentValue,
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildDropdownItemWidget(
    DropdownItem<T> item, {
    bool isSelectedItem = false,
  }) {
    if (widget.showIcons && item.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 20, height: 20, child: item.icon!),
          const SizedBox(width: 4),
          Flexible(child: Text(item.label, overflow: TextOverflow.ellipsis)),
        ],
      );
    } else {
      return Text(item.label, overflow: TextOverflow.ellipsis);
    }
  }

  Widget _buildStaticDropdown(BuildContext context, TextTheme textTheme) {
    final selectedItem = _findSelectedItem(widget.dropdownValue);
    Widget displayContent;
    if (selectedItem != null) {
      List<Widget> rowChildren = [];
      if (selectedItem.icon != null && widget.showIcons) {
        rowChildren.add(
          SizedBox(
            width: 24,
            height: 24,
            child: Opacity(
              opacity: widget.isDisabled || widget.dropDisabled ? 0.85 : 1.0,
              child: selectedItem.icon!,
            ),
          ),
        );
        rowChildren.add(const SizedBox(width: 8));
      }
      rowChildren.add(
        Flexible(
          child: Text(
            selectedItem.label,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: (widget.isDisabled || widget.dropDisabled)
                  ? AppColors.dark2
                  : AppColors.dark3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      displayContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: rowChildren,
      );
    } else {
      displayContent = const SizedBox.shrink();
    }
    Widget displayContainer = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: displayContent,
    );
    if (widget.dropdownIdentifier != null) {
      return Semantics(
        label: widget.dropdownIdentifier,
        value: selectedItem?.label ?? "No seleccionado",
        enabled: !widget.isDisabled && !widget.dropDisabled,
        readOnly: true,
        child: displayContainer,
      );
    }
    return displayContainer;
  }

  Widget _buildDynamicDropdown(
    BuildContext context,
    TextTheme textTheme,
    bool hasError,
  ) {
    final sortedItems = List<DropdownItem<T>>.from(widget.dropdownItems)
      ..sort((a, b) => a.label.compareTo(b.label));
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        value: _findSelectedItem(widget.dropdownValue)?.value,
        items: sortedItems.map((item) {
          return DropdownMenuItem<T>(
            value: item.value,
            child: _buildDropdownItemWidget(item),
          );
        }).toList(),

        onChanged: widget.isDisabled ? null : _handleDropdownChange,
        style: textTheme.titleSmall?.copyWith(
          color: AppColors.dark,
          fontWeight: FontWeight.bold,
        ),
        selectedItemBuilder: (context) {
          return sortedItems.map((item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: _buildDropdownItemWidget(item, isSelectedItem: true),
            );
          }).toList();
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
          height: 55,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 20,
          iconEnabledColor: hasError ? AppColors.failure : AppColors.dark2,
          iconDisabledColor: AppColors.light,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.dark3,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 16),

        ),
        dropdownSearchData: DropdownSearchData<T>(
          searchController: _searchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _searchController,
              keyboardType: widget.dropdownSearchInputType,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: widget.searchHint,
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColors.dark3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            final dropdownItem = _findSelectedItem(item.value);
            return dropdownItem?.label.toLowerCase().contains(
                  searchValue.toLowerCase(),
                ) ??
                false;
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            _searchController.clear();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<TextInputFormatter> formatters = [
      CurrencyInputFormatter(max: widget.max, decimals: widget.decimals),
    ];

    return FormField<String>(
      initialValue: widget.inputController.text,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      enabled: !widget.isDisabled,
      builder: (FormFieldState<String> field) {
        final bool inputHasError = field.hasError;
        final String? inputErrorText = field.errorText;
        final bool dropdownHasError = _dropdownErrorText != null;
        final bool hasAnyError = inputHasError || dropdownHasError;

        final inputWidget = Container(
          height: 55,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.light2,

            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasAnyError ? AppColors.failure : AppColors.dark3,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                color: AppColors.light,
                child: widget.dropDisabled
                    ? _buildStaticDropdown(context, textTheme)
                    : _buildDynamicDropdown(context, textTheme, hasAnyError),
              ),
              Container(width: 1, color: AppColors.dark3),
              Expanded(
                child: TextFormField(
                  controller: widget.inputController,
                  focusNode: _inputFocusNode,
                  style: textTheme.titleMedium?.copyWith(
                    color: widget.isDisabled || widget.inputDisabled
                        ? AppColors.dark2
                        : AppColors.dark,
                    fontWeight: FontWeight.bold,
                  ),

                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    hintText: widget.inputHint ?? "0,00",
                    hintStyle: textTheme.titleMedium?.copyWith(
                      color: AppColors.dark2,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  enabled: !widget.isDisabled && !widget.inputDisabled,
                  enableInteractiveSelection: widget.enableInteractiveSelection,
                  inputFormatters: formatters,
                  onChanged: (formattedValue) {
                    widget.inputChange?.call(formattedValue);
                    field.didChange(formattedValue);
                  },
                  onFieldSubmitted: widget.onTapEnter,
                ),
              ),
            ],
          ),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  widget.label!,
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.dark2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            inputWidget,
            if (inputHasError && inputErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Text(
                  inputErrorText,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.failure,
                  ),
                ),
              ),
            if (dropdownHasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Text(
                  _dropdownErrorText!,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.failure,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
