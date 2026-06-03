import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wiigold/app/common/utils/phones.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/config/environment.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicPhoneNumberInput extends StatelessWidget {
  final String label;
  final String? hint;

  final RxString phoneCode;

  final TextEditingController phoneCodeCtrl;
  final TextEditingController phoneNumberCtrl;

  final DropdownSemantics? phoneCodeSemanticSettings;
  final InputSemantics? phoneNumberSemanticSettings;

  final bool isDisabled;
  final bool isRequiered;

  final TextStyle? labelStyle;
  final TextStyle? inputStyle;

  final AutovalidateMode autoValidateMode;

  final Widget? leading;
  final Widget? trailing;

  const DynamicPhoneNumberInput({
    super.key,
    required this.label,
    required this.phoneCode,
    required this.phoneCodeCtrl,
    required this.phoneNumberCtrl,
    this.hint,
    this.isRequiered = true,
    this.isDisabled = false,
    this.labelStyle,
    this.inputStyle,
    this.leading,
    this.trailing,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.phoneCodeSemanticSettings,
    this.phoneNumberSemanticSettings,
  });

  String? _validatePhone(String? value) {
    if (phoneCode.value.isEmpty && isRequiered) {
      return 'widgets.phone_input.placeholder'.tr;
    }

    if (value == null || value.isEmpty) {
      return isRequiered ? 'validation.empty_field'.tr : null;
    }

    if (phoneCode.value.isNotEmpty) {
      return Validations.validationInputPhone(
        value,
        phoneCode: phoneCode.value,
      );
    }

    return null;
  }

  Widget _buildDropdownItemWidget(DropdownItem<String> item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.icon != null) SizedBox(width: 35, child: item.icon!),
        const SizedBox(width: 8),
        Expanded(child: Text(item.label, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dropdownItems = phoneCodes.map((phoneCodeItem) {
      return DropdownItem(
        value: phoneCodeItem.phoneCode,
        label: phoneCodeItem.phoneCode,
        icon: CountryFlag.fromCountryCode(
          phoneCodeItem.countryCode,
          width: 20,
          height: 25,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              textTheme.titleSmall?.copyWith(
                color: AppColors.dark2,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        FormField<String>(
          initialValue: phoneNumberCtrl.text,
          validator: _validatePhone,
          autovalidateMode: autoValidateMode,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.dark3),

                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      title: isDisabled
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: CountryFlag.fromCountryCode(
                                    getPhoneCode(phoneCode.value).countryCode,
                                    width: 35,
                                    height: 25,
                                  ),
                                ),

                                Text(
                                  phoneCode.value.isNotEmpty &&
                                          phoneNumberCtrl.text.isNotEmpty
                                      ? "${phoneCode.value} ${phoneNumberCtrl.text}"
                                      : '',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: _formatSemanticsDropdown(
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        isDense: true,
                                        value: phoneCode.value.isEmpty
                                            ? null
                                            : phoneCode.value,
                                        hint: Text(
                                          'widgets.phone_input.code.placeholder'
                                              .tr,
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: AppColors.dark2,
                                          ),
                                        ),

                                        items: dropdownItems.map((item) {
                                          return DropdownMenuItem<String>(
                                            value: item.value,
                                            child: _buildDropdownItemWidget(
                                              item,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (selectedId) {
                                          if (selectedId != null &&
                                              selectedId.isNotEmpty &&
                                              selectedId != phoneCode.value) {
                                            phoneCode.value = selectedId;
                                            SchedulerBinding.instance
                                                .addPostFrameCallback((_) {
                                                  if (context.mounted) {
                                                    phoneCodeCtrl.text =
                                                        selectedId;
                                                    phoneNumberCtrl.text = '';
                                                    state.didChange('');
                                                  }
                                                });
                                          }
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          padding: EdgeInsets.zero,
                                          height: 40,
                                        ),
                                        iconStyleData: IconStyleData(
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          iconSize: 20,
                                          iconEnabledColor: AppColors.dark2,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 300,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            color: AppColors.dark3,
                                          ),
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                            ),
                                        dropdownSearchData: DropdownSearchData(
                                          searchController: phoneCodeCtrl,
                                          searchInnerWidgetHeight: 50,
                                          searchInnerWidget: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: TextFormField(
                                              controller: phoneCodeCtrl,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
                                                hintText:
                                                    'widgets.phone_input.code.search_placeholder'
                                                        .tr,
                                                hintStyle: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.dark2,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),

                                          searchMatchFn: (item, searchValue) {
                                            final dropdownItem = dropdownItems
                                                .firstWhere(
                                                  (e) => e.value == item.value,
                                                );
                                            return dropdownItem.label
                                                .toLowerCase()
                                                .contains(
                                                  searchValue.toLowerCase(),
                                                );
                                          },
                                        ),
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            phoneCodeCtrl.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: _formatSemanticInput(
                                    TextFormField(
                                      controller: phoneNumberCtrl,
                                      style:
                                          inputStyle ??
                                          textTheme.titleMedium?.copyWith(
                                            color: AppColors.dark,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) {
                                        state.didChange(value);
                                      },
                                      decoration: InputDecoration(
                                        hintText:
                                            hint ??
                                            'widgets.phone_input.label'.tr,
                                        hintStyle: textTheme.bodyLarge
                                            ?.copyWith(
                                              color: AppColors.dark2,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      maxLength: 13,
                                      buildCounter:
                                          (
                                            context, {
                                            required currentLength,
                                            required isFocused,
                                            maxLength,
                                          }) => null,
                                      enabled: !isDisabled,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      leading: leading,
                      trailing: trailing,
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      state.errorText!,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.failure,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _formatSemanticInput(Widget input) {
    if (!EnvironmentConfig.inRenderSemantics ||
        phoneNumberSemanticSettings == null) {
      return input;
    }
    return Semantics(
      label: phoneNumberSemanticSettings!.semanticLabel ?? label,
      hint:
          phoneNumberSemanticSettings!.hint ??
          hint ??
          'Ingresa número de teléfono',
      textField: true,
      identifier: phoneNumberSemanticSettings!.identifier,
      enabled: !isDisabled,
      child: input,
    );
  }

  Widget _formatSemanticsDropdown(Widget dropdown) {
    if (!EnvironmentConfig.inRenderSemantics ||
        phoneCodeSemanticSettings == null) {
      return dropdown;
    }
    return Semantics(
      button: true,
      label: phoneCodeSemanticSettings!.semanticLabel ?? 'Código de país',
      hint: phoneCodeSemanticSettings!.hint ?? 'Selecciona un código de país',
      value: phoneCode.value,
      identifier: phoneCodeSemanticSettings!.identifier,
      enabled: !isDisabled,
      child: dropdown,
    );
  }
}
