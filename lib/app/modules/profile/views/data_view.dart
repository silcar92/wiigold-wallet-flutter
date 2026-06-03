import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_datetime.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_phonenumber_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/theme/Colors.dart';

//? CONTROLLER

//? THEMES & IMAGES

//? WIDGETS

//? OTHERS

class DataView extends StatelessWidget {
  const DataView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: profileController.isLoading,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(showLogo: true),
      onReady: profileController.synceProfile,
      onRefresh: profileController.synceProfile,
      isContentCentered: false,
      body: DataForm(),
    );
  }
}

class DataForm extends GetView<ProfileController> {
  const DataForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        DynamicDivider(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'profile.data_view.title'.tr,
              style: textTheme.displayLarge?.copyWith(color: AppColors.main),
            ),
          ],
        ),
        //? FROM CORE
        Obx(
          () => controller.inInputPassword.value == true
              ? InputPassword()
              : DataFormCore(),
        ),
      ],
    );
  }
}

class DataFormCore extends GetView<ProfileController> {
  const DataFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget nameInput() {
      return DynamicInput(
        semanticSettings: InputSemantics(identifier: 'name_profileForm'),
        label: 'profile.data_view.full_name_label'.tr,
        controller: controller.nameController,
        inputType: TextInputType.text,
        isDisabled: true,
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.dark2,
          fontWeight: FontWeight.w600,
          height: .5,
        ),
        inputStyle: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        inputDecoration: InputDecoration(labelStyle: textTheme.displayLarge),
      );
    }

    Widget identifierInput() {
      return DynamicInput(
        semanticSettings: InputSemantics(identifier: 'identifier_profileForm'),
        label: 'profile.data_view.document_number_label'.tr,
        controller: controller.identifierController,
        inputType: TextInputType.text,
        isDisabled: true,
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.dark2,
          fontWeight: FontWeight.w600,
          height: .5,
        ),
        inputStyle: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        inputDecoration: InputDecoration(labelStyle: textTheme.displayLarge),
      );
    }

    Widget emailInput() {
      return DynamicInput(
        semanticSettings: InputSemantics(identifier: 'email_profileForm'),
        label: 'profile.data_view.email_label'.tr,
        controller: controller.emailController,
        inputType: TextInputType.text,
        validationPatter: Validations.validationInputEmail,
        isDisabled: !controller.onChangeEmail.value,
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.dark2,
          fontWeight: FontWeight.w600,
          height: .5,
        ),
        inputStyle: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        inputDecoration: InputDecoration(labelStyle: textTheme.displayLarge),
        leading: controller.onChangeEmail.value
            ? GestureDetector(
                onTap: controller.resetForm,
                child: Icon(Icons.close, size: 20, color: AppColors.failure),
              )
            : null,
        trailing: controller.onChangeEmail.value
            ? GestureDetector(
                onTap: controller.saveEmail,
                child: Icon(
                  Icons.check_box,
                  size: 30,
                  color: AppColors.success,
                ),
              )
            : GestureDetector(
                onTap: () {
                  controller.onChangeEmail.value = true;
                },
                child: Icon(
                  Icons.create_sharp,
                  size: 30,
                  color: AppColors.dark3,
                ),
              ),
      );
    }

    Widget phoneInput() {
      return DynamicPhoneNumberInput(
        label: 'profile.data_view.phone_number_label'.tr,
        phoneCode: controller.phoneCode,
        phoneCodeCtrl: controller.phoneLiteralController,
        phoneNumberCtrl: controller.phoneNumberController,
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.dark2,
          fontWeight: FontWeight.w600,
          height: .5,
        ),
        inputStyle: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        isRequiered: false,
        isDisabled: !controller.onChangePhone.value,
        leading: controller.onChangePhone.value
            ? GestureDetector(
                onTap: controller.resetForm,
                child: Icon(Icons.close, size: 20, color: AppColors.failure),
              )
            : null,
        trailing: controller.onChangePhone.value
            ? GestureDetector(
                onTap: controller.savePhoneNumber,
                child: Icon(
                  Icons.check_box,
                  size: 30,
                  color: AppColors.success,
                ),
              )
            : GestureDetector(
                child: Icon(
                  Icons.create_sharp,
                  size: 30,
                  color: AppColors.dark3,
                ),
                onTap: () {
                  controller.onChangePhone.value = true;
                },
              ),
      );
    }

    Widget birthdayInput() {
      return DynamicDateTime(
        label: 'profile.data_view.birth_date_label'.tr,
        controller: controller.birthdayController,
        hint: 'profile.data_view.birth_date_hint'.tr,
        includeTime: false,
        isDisabled: true,
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.dark2,
          fontWeight: FontWeight.w600,
          height: .5,
        ),
        inputStyle: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        inputDecoration: InputDecoration(
          labelStyle: textTheme.displayLarge,
          border: InputBorder.none,
        ),
      );
    }

    Widget addressSection() {
      return controller.onChangeAddress.value == false
          ? Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.data_view.address_label'.tr,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.dark2,
                    fontWeight: FontWeight.w600,
                    height: .5,
                  ),
                ),
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      controller.fullAddress.value,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: GestureDetector(
                      child: Icon(
                        Icons.create_sharp,
                        size: 30,
                        color: AppColors.dark3,
                      ),
                      onTap: () {
                        controller.onChangeAddress.value = true;
                      },
                    ),
                  ),
                ),
              ],
            )
          : Flex(
              direction: Axis.vertical,
              children: [
                Obx(
                  () => DynamicDropdownInput(
                    semanticSettings: DropdownSemantics(
                      identifier: 'countryCode_authForm_step1',
                    ),
                    label: 'profile.data_view.country_label'.tr,
                    items: controller.countries.map((c) {
                      return DropdownItem(value: "${c.id}", label: c.name);
                    }).toList(),
                    value: controller.selectedCountryId.value,
                    onChanged: (selectedId) {
                      controller.updateSelectedCountry(selectedId!);
                    },
                    isDisabled: !controller.onChangeAddress.value,
                    dropdownSearchInputType: TextInputType.text,
                    searchController: controller.countryController,
                    showIcons: true,
                    searchable: true,
                    hint: 'profile.data_view.country_hint'.tr,
                  ),
                ),
                if (controller.selectedCountryId.value != '') ...[
                  DynamicDivider(height: 20),
                  DynamicDropdownInput(
                    semanticSettings: DropdownSemantics(
                      identifier: 'regionName_authForm_step1',
                    ),
                    label: 'profile.data_view.region_label'.tr,
                    dropdownSearchInputType: TextInputType.text,
                    items: controller.regions.map((r) {
                      return DropdownItem(value: "${r.id}", label: r.name);
                    }).toList(),
                    value: controller.selectedRegionId.value,
                    onChanged: (value) {
                      controller.updateSelectedRegion(value ?? '');
                    },
                    searchController: controller.regionController,
                    validator: Validations.validationInputText,
                    isDisabled: !controller.onChangeAddress.value,
                    searchable: true,
                  ),
                ],
                if (controller.selectedCountryId.value != '' &&
                    controller.selectedRegionId.value != '') ...[
                  DynamicDivider(height: 20),
                  DynamicInput(
                    semanticSettings: InputSemantics(
                      identifier: 'address_authForm_step1',
                    ),
                    label: 'profile.data_view.address_label'.tr,
                    controller: controller.addressController,
                    inputType: TextInputType.text,
                    validationPatter: (value) =>
                        Validations.validationInputText(
                          value,
                          minLength: 5,
                          maxLength: 100,
                        ),
                    isDisabled: !controller.onChangeAddress.value,
                  ),
                ],

                DynamicDivider(height: 20),

                DynamicNumeric(
                  semanticSettings: NumericSemantics(
                    identifier: 'zipCode_authForm_step1',
                  ),
                  label: 'profile.data_view.postal_code_label'.tr,
                  controller: controller.postalCodeController,
                  allowDecimals: false,
                  validationPatter: Validations.validationInputNumericText,
                  max: 9999999999,
                  hint: "",
                  disableNumericFormatter: true,
                ),

                DynamicDivider(height: 20),

                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.close,
                        size: 40,
                        color: AppColors.failure,
                      ),
                      onTap: () {
                        controller.onChangeAddress.value = false;
                      },
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      child: Icon(
                        Icons.check_box,
                        size: 40,
                        color: AppColors.success,
                      ),
                      onTap: () {
                        controller.saveAddress();
                      },
                    ),
                  ],
                ),
                Divider(),
              ],
            );
    }

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: 'profileForm'),
      formKey: controller.dataFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          nameInput(),
          DynamicDivider(height: 20),
          identifierInput(),
          DynamicDivider(height: 20),
          birthdayInput(),
          DynamicDivider(height: 20),
          Obx(() => emailInput()),
          DynamicDivider(height: 20),
          Obx(() => phoneInput()),
          DynamicDivider(height: 20),
          Obx(() => addressSection()),
          DynamicDivider(height: 20),
          DynamicDivider(height: 80),
        ],
      ),
    );
  }
}

class InputPassword extends GetView<ProfileController> {
  const InputPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      formKey: controller.inputPasswordFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          DynamicDivider(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  'profile.data_view.password_prompt'.tr,
                  style: textTheme.titleLarge,
                ),
              ),
            ],
          ),
          DynamicDivider(height: 15),
          /*
          DynamicPin(
            validationPatter: Validations.validationInputPass,
            controller: controller.passwordController,
          ),
          */
          DynamicDivider(height: 30),
          DynamicButton(
            semanticSettings: ButtonSemantics(identifier: 'submit_form_buttom'),
            onPressed: controller.validateNewPasswordForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'profile.data_view.validate_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.dark),
                ),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.dark),
              ],
            ),
          ),
          DynamicDivider(height: 10),
          DynamicButton(
            onPressed: controller.resetForm,
            borderColor: AppColors.light,
            baseColor: AppColors.dark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Icon(Icons.arrow_back, size: 20, color: AppColors.light),
                Text(
                  'profile.data_view.cancel_button'.tr,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.light,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
