import 'package:flutter/material.dart';

//? THEME & IMAGES

//? WIDGETS
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/config/environment.dart';
import 'package:wiigold/theme/Colors.dart';

class DropdownItem<T> {
  final String label;
  final T value;
  final Widget? icon;

  const DropdownItem({required this.label, required this.value, this.icon});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownItem<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class DropdownSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;
  final String? errorMessage;

  const DropdownSemantics({
    required this.identifier,
    this.semanticLabel,
    this.hint,
    this.errorMessage,
  });
}

class DynamicDropdownInput<T> extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final ButtonStyleData? inputStyle;
  final TextStyle? visibleInputStyle;

  final String? hint;
  final List<DropdownItem<T>> items;
  final T? value;

  final DropdownSemantics? semanticSettings;

  final String searchHint;
  final TextEditingController? searchController;

  final Widget? leading;

  final FormFieldValidator<T?>? validator;
  final AutovalidateMode autovalidateMode;

  final TextInputType dropdownSearchInputType;

  final bool isDisabled;
  final bool sourceSorted;
  final bool searchable;
  final bool showIcons;

  final Function(T?) onChanged;

  const DynamicDropdownInput({
    super.key,
    this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.searchController,
    this.inputStyle,
    this.visibleInputStyle,
    this.hint,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    required this.dropdownSearchInputType,
    this.isDisabled = false,
    this.labelStyle,
    this.leading,
    this.sourceSorted = true,
    this.searchable = true,
    this.searchHint = 'Buscar...',
    this.semanticSettings,
    this.showIcons = false,
  });

  DropdownItem<T>? _findSelectedItem(T? currentValue) {
    if (currentValue == null) return null;
    try {
      return items.firstWhere((item) => item.value == currentValue);
    } catch (e) {
      return null;
    }
  }

  List<DropdownItem<T>> _getSortedItems() {
    return List<DropdownItem<T>>.from(items)
      ..sort((a, b) => a.label.compareTo(b.label));
  }

  Widget _buildItemWidget(DropdownItem<T> item, {bool isSelectedItem = false}) {
    if (showIcons && item.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 40, child: item.icon!),
          const SizedBox(width: 8),
          isSelectedItem
              ? Text(item.label, overflow: TextOverflow.ellipsis)
              : Expanded(
                  child: Text(item.label, overflow: TextOverflow.ellipsis),
                ),
        ],
      );
    } else {
      return Text(item.label, overflow: TextOverflow.ellipsis);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color errorColor = AppColors.failure;

    return FormField<T?>(
      initialValue: _validateValue(value),
      validator: validator,
      autovalidateMode: autovalidateMode,
      enabled: !isDisabled,
      builder: (FormFieldState<T?> field) {
        internalOnChanged(T? newValue) {
          onChanged(newValue);
          field.didChange(newValue);
          if (newValue != null && searchController != null) {
            searchController?.clear();
          }
        }

        final sortedItems = sourceSorted ? _getSortedItems() : items;

        List<DropdownMenuItem<T>> buildDropdownItems() {
          return sortedItems.map((item) {
            return DropdownMenuItem<T>(
              value: item.value,
              child: _buildItemWidget(item, isSelectedItem: false),
            );
          }).toList();
        }

        final dropdownWidget = Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<T>(
                  isExpanded: true,
                  isDense: true,
                  hint: Text(
                    hint ?? 'Selecciona una opción',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.dark2,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  items: buildDropdownItems(),
                  value: _validateValue(field.value),
                  style:
                      visibleInputStyle ??
                      textTheme.titleMedium?.copyWith(color: AppColors.dark2),
                  selectedItemBuilder: (context) {
                    return sortedItems.map((item) {
                      return _buildItemWidget(item, isSelectedItem: true);
                    }).toList();
                  },
                  onChanged: isDisabled ? null : internalOnChanged,
                  buttonStyleData: _buildInputStyle(hasError: field.hasError),
                  iconStyleData: IconStyleData(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    iconEnabledColor: field.hasError
                        ? errorColor
                        : AppColors.dark2,
                    iconDisabledColor: AppColors.dark2,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.dark3,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all(6),
                      thumbVisibility: WidgetStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  dropdownSearchData: searchable && !isDisabled
                      ? DropdownSearchData<T>(
                          searchController: searchController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              controller: searchController,
                              keyboardType: dropdownSearchInputType,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: searchHint,
                                hintStyle: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.dark2,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.dark),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.dark),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            final selectedItem = _findSelectedItem(item.value);
                            if (selectedItem == null) return false;

                            return selectedItem.label.toLowerCase().contains(
                                  searchValue.toLowerCase(),
                                ) ||
                                item.value.toString().toLowerCase().contains(
                                  searchValue.toLowerCase(),
                                );
                          },
                        )
                      : null,
                  onMenuStateChange: (isOpen) {
                    if (!isOpen && searchController != null) {
                      searchController?.clear();
                    }
                  },
                ),
              ),
            ),
            if (leading != null) leading!,
          ],
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null)
              Text(
                label!,
                style:
                    labelStyle ??
                    textTheme.titleSmall?.copyWith(
                      color: AppColors.dark2,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            if (label != null) DynamicDivider(height: 8),
            _formatSemantics(dropdownWidget),
            if (field.hasError && field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 2.0),
                child: Text(
                  field.errorText!,
                  style:
                      textTheme.bodySmall?.copyWith(color: errorColor) ??
                      TextStyle(color: errorColor, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  ButtonStyleData _buildInputStyle({bool hasError = false}) {
    if (inputStyle != null) {
      return inputStyle!;
    }

    final defaultBorderColor = AppColors.dark3;
    final errorBorderColor = AppColors.failure;

    return ButtonStyleData(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: hasError ? errorBorderColor : defaultBorderColor,
        ),
      ),
    );
  }

  T? _validateValue(T? currentValue) {
    if (currentValue == null) return null;
    final bool valueExists = items.any((item) => item.value == currentValue);
    return valueExists ? currentValue : null;
  }

  Widget _formatSemantics(Widget dropdown) {
    final selectedItemLabel = _findSelectedItem(value)?.label;
    bool shouldApplySemantics = EnvironmentConfig.inRenderSemantics;

    if (!shouldApplySemantics) return dropdown;

    return semanticSettings != null
        ? Semantics(
            textField: true,
            label: semanticSettings!.semanticLabel ?? label,
            hint: semanticSettings!.hint ?? hint,
            value:
                selectedItemLabel ??
                semanticSettings?.hint ??
                (value?.toString() ?? ''),
            identifier: semanticSettings!.identifier,
            enabled: !isDisabled,
            child: dropdown,
          )
        : dropdown;
  }
}
