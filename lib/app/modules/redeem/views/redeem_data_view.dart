import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_phonenumber_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/redeem/controllers/redeem_data_controller.dart';
import 'package:wiigold/app/modules/redeem/widgets/redeem_appbar_title.dart';
import 'package:wiigold/theme/Colors.dart';

//? VALIDATIONS

//? WIDGETS

//? CONTROLLER

//? THEMES & IMAGES

class RedeemDataView extends GetView<RedeemDataController> {
  const RedeemDataView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(showLogo: false, title: RedeemAppbarTitle()),
      onRefresh: controller.chargeData,
      onReady: controller.initialCharge,
      body: RedeemDataPage(),
    );
  }
}

class RedeemDataPage extends GetView<RedeemDataController> {
  const RedeemDataPage({super.key});

  @override
  //? ROOT PAGE
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.displayLarge?.copyWith(height: 1),
                    children: [
                      TextSpan(text: 'redeem.data_view.title_part1'.tr),
                      TextSpan(
                        text: 'redeem.data_view.title_part2_highlight'.tr,
                        style: TextStyle(
                          color: AppColors.main,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          DynamicDivider(height: 25),

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    style: textTheme.displaySmall?.copyWith(
                      color: AppColors.main,
                    ),
                    "${controller.quantityToken.value.toHauvNumericString(decimals: 2)} ${'redeem.data_view.grams_abbreviation'.tr}",
                  ),
                ),
              ],
            ),
          ),

          DynamicDivider(height: 75),

          RedeemDataCore(),
        ],
      ),
    );
  }
}

class RedeemDataCore extends GetView<RedeemDataController> {
  const RedeemDataCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: "redeemDataForm"),
      formKey: controller.redeemDataFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          DynamicInput(
            semanticSettings: InputSemantics(
              identifier: 'fullName_redeemDataForm',
            ),
            label: 'redeem.data_view.full_name_label'.tr,
            controller: controller.nameController,
            inputType: TextInputType.text,
            validationPatter: (value) => Validations.validationInputName(
              value,
              minLength: 5,
              maxLength: 50,
            ),
          ),

          DynamicDivider(height: 20),

          Obx(
            () => DynamicDropdownInput(
              semanticSettings: DropdownSemantics(
                identifier: 'countryCode_redeemDataForm',
              ),
              label: 'redeem.data_view.country_label'.tr,
              items: controller.countries.map((c) {
                return DropdownItem(value: "${c.id}", label: c.name);
              }).toList(),
              value: controller.selectedCountryId.value,
              onChanged: (selectedId) {
                controller.updateSelectedCountry(selectedId!);
              },
              dropdownSearchInputType: TextInputType.text,
              searchController: controller.countryController,
              showIcons: true,
              searchable: true,
              hint: 'redeem.data_view.country_hint'.tr,
            ),
          ),

          DynamicDivider(height: 20),

          Obx(() {
            if (controller.selectedCountryId.value != '') {
              return Flex(
                direction: Axis.vertical,
                children: [
                  DynamicDropdownInput(
                    semanticSettings: DropdownSemantics(
                      identifier: 'regionName_redeemDataForm',
                    ),
                    label: 'redeem.data_view.region_label'.tr,
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

                    searchable: true,
                  ),
                  DynamicDivider(height: 20),
                ],
              );
            }

            return SizedBox.shrink();
          }),

          Obx(() {
            if (controller.selectedCountryId.value != '' &&
                controller.selectedRegionId.value != '') {
              return Flex(
                direction: Axis.vertical,
                children: [
                  DynamicInput(
                    semanticSettings: InputSemantics(
                      identifier: 'address_redeemDataForm',
                    ),
                    label: 'redeem.data_view.address_label'.tr,
                    controller: controller.addressController,
                    inputType: TextInputType.text,
                    validationPatter: (value) => Validations.validationAddress(
                      value,
                      minLength: 5,
                      maxLength: 100,
                    ),
                  ),
                  DynamicDivider(height: 20),
                ],
              );
            }

            return SizedBox.shrink();
          }),

          DynamicNumeric(
            semanticSettings: NumericSemantics(
              identifier: 'zipCode_redeemDataForm',
            ),
            label: 'redeem.data_view.postal_code_label'.tr,
            controller: controller.postalCodeController,
            allowDecimals: false,
            validationPatter: Validations.validationInputNumericText,
            max: 9999999999,
            hint: "",
            disableNumericFormatter: true,
          ),

          DynamicDivider(height: 20),

          DynamicPhoneNumberInput(
            phoneNumberSemanticSettings: InputSemantics(
              identifier: "phone_redeemDataForm",
            ),
            label: 'redeem.data_view.phone_number_label'.tr,
            phoneCode: controller.phoneCode,
            phoneCodeCtrl: controller.phoneLiteralController,
            phoneNumberCtrl: controller.phoneNumberController,
            labelStyle: textTheme.bodyLarge?.copyWith(
              color: AppColors.dark2,
              fontWeight: FontWeight.w600,
              height: .5,
            ),

            isRequiered: false,
          ),

          DynamicDivider(height: 75),

          DynamicButton(
            semanticSettings: ButtonSemantics(
              identifier: 'submit_redeemDataForm',
            ),
            onPressed: controller.validateRedeemDataForm,
            disabledColor: AppColors.dark3,
            isGradient: true,
            baseColor: AppColors.main,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'redeem.data_view.continue_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
              ],
            ),
          ),

          DynamicDivider(height: 10),

          DynamicButton(
            semanticSettings: ButtonSemantics(
              identifier: 'back_redeemDataForm',
            ),
            baseColor: AppColors.transparent,
            borderColor: AppColors.main,
            onPressed: () => {Get.back()},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Icon(Icons.arrow_back, size: 20, color: AppColors.main),
                Text(
                  'redeem.data_view.modify_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.main),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
