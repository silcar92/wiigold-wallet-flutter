import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_loader.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';

//? CONTROLLER

//? THEMES & IMAGES

//? WIDGETS

//? others
import 'package:wiigold/app/modules/auth/controllers/auth_controller.dart';
import 'package:wiigold/app/modules/auth/widgets/auth_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.toHome,
      appBar: DynamicAppBar(showLogo: false, title: AuthAppbarTitle()),
      onReady: (){
        controller.initialCharge();
      },
      body: AuthPage(),
    );
  }
}

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: textTheme.displayLarge?.copyWith(height: 1.1),
                    children: [
                      TextSpan(text: 'auth.auth_view.title_part1'.tr),
                      TextSpan(
                        text: 'auth.auth_view.title_part2_highlight'.tr,
                        style: TextStyle(color: AppColors.main),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                'auth.auth_view.subtitle'.tr,
                style: textTheme.titleMedium?.copyWith(
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ),

        VerifyFormCore(),
      ],
    );
  }
}

class TermsLinks extends GetView<AuthController> {
  const TermsLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      spacing: 10,
      children: [
        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'privacy_otpLink'),
          onPressed: () {
            final financialController = Get.find<FinancialController>();
            financialController.openPrivacyPolicy();
          },
          baseColor: AppColors.dark,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'auth.auth_view.terms_privacy_link'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.light),
              ),
              Icon(Icons.double_arrow, size: 30, color: AppColors.dark2),
            ],
          ),
        ),
        DynamicButton(
          semanticSettings: ButtonSemantics(identifier: 'conditions_otpLink'),
          baseColor: AppColors.dark,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 8,
            children: [
              Text(
                'auth.auth_view.terms_conditions_link'.tr,
                style: textTheme.titleMedium?.copyWith(color: AppColors.light),
              ),
              Icon(Icons.double_arrow, size: 30, color: AppColors.dark2),
            ],
          ),
          onPressed: () => controller.viewTermAndCondictions(),
        ),
      ],
    );
  }
}

class VerifyFormCore extends GetView<AuthController> {
  const VerifyFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: DynamicForm(
        semanticSettings: FormSemantics(identifier: 'authForm_step1'),
        formKey: controller.authFormKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          spacing: 20,
          children: [
            Obx(
              () => DynamicDropdownInput(
                semanticSettings: DropdownSemantics(
                  identifier: 'countryCode_authForm_step1',
                ),
                label: 'auth.auth_view.form.country_input'.tr,
                items: controller.countries.map((c) {
                  return DropdownItem(value: "${c.id}", label: c.name);
                }).toList(),
                value: controller.selectedCountryId.value,
                validator: Validations.validationDropdown,
                onChanged: (selectedId) {
                  controller.updateSelectedCountry(selectedId!);
                },
                dropdownSearchInputType: TextInputType.text,
                searchController: controller.countryController,
                showIcons: true,
                searchable: true,
                hint: 'Selecciona tu país...',
              ),
            ),

            Obx(() {
              if (controller.selectedCountryId.value.isNotEmpty &&
                  controller.isLoading.value &&
                  controller.selectedCountryId.value.isNotEmpty) {
                return DynamicLoading();
              }

              return controller.regions.value.isNotEmpty
                  ? DynamicDropdownInput(
                      semanticSettings: const DropdownSemantics(
                        identifier: 'regionName_authForm_step1',
                      ),
                      label: 'auth.auth_view.form.region_input'.tr,
                      dropdownSearchInputType: TextInputType.text,
                      items: controller.regions.map((r) {
                        return DropdownItem(
                          value: r.id.toString(),
                          label: r.name,
                        );
                      }).toList(),
                      value: controller.selectedRegionId.value,
                      validator: Validations.validationDropdown,
                      onChanged: (value) {
                        controller.updateSelectedRegion(value ?? '');
                      },
                      searchController: controller.regionController,
                    )
                  : const SizedBox.shrink();
            }),

            Obx(() {
              return controller.selectedCountryId.value != '' &&
                      controller.selectedRegionId.value != ''
                  ? DynamicInput(
                      semanticSettings: InputSemantics(
                        identifier: 'address_authForm_step1',
                      ),
                      label: 'auth.auth_view.form.address_input'.tr,
                      controller: controller.addressController,
                      inputType: TextInputType.text,
                      validationPatter: (value) =>
                          Validations.validationAddress(
                            value,
                            minLength: 5,
                            maxLength: 100,
                          ),
                    )
                  : const SizedBox.shrink();
            }),

            DynamicNumeric(
              semanticSettings: NumericSemantics(
                identifier: 'zipCode_authForm_step1',
              ),
              label: "Código Postal",
              controller: controller.postalCodeController,
              allowDecimals: false,
              validationPatter: Validations.validationInputNumericText,
              max: 9999999999,
              hint: "",
              disableNumericFormatter: true,
            ),

            DynamicDivider(height: 10),

            Obx(
              () => DynamicButton(
                isDisabled: controller.initVerification.value,
                isGradient: true,
                baseColor: AppColors.main,
                onPressed: controller.validateAuthForm,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Text(
                      'auth.auth_view.submit_button'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.light,
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

