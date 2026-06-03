import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_phonenumber_input.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_auth_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/data/models/entities/claim_model.dart';
import 'package:wiigold/app/modules/claim/controllers/claim_controller.dart';

import 'package:wiigold/app/routers/app_routes.dart';

//? CONTROLLER
import 'package:wiigold/app/modules/login/controllers/login_controller.dart';

//? THEMES & IMAGES
import 'package:wiigold/theme/Colors.dart';

//? WIDGETS

//? OTHERS
import 'package:wiigold/app/common/utils/validations.dart';

class ClaimView extends GetView<ClaimController> {
  const ClaimView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.standard,
      onCustomBack: () {
        Get.back();
      },
      appBar: DynamicAppBar(showAutoBackButton: true, showLogo: false),
      isContentCentered: true,
      body: ClaimForm(),
    );
  }
}

class ClaimForm extends GetView<ClaimController> {
  const ClaimForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'claim.claim_view.title'.tr,
                style: textTheme.displayLarge?.copyWith(color: AppColors.main),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'claim.claim_view.caption'.tr,

                style: textTheme.titleMedium,
              ),
            ),
          ],
        ),

        ClaimFormCore(),
      ],
    );
  }
}

class ClaimFormCore extends GetView<ClaimController> {
  const ClaimFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: DynamicForm(
        semanticSettings: const FormSemantics(identifier: 'loginForm_step1'),
        formKey: controller.claimFormKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          children: [
            DynamicInput(
              label: 'claim.claim_view.form.name_label'.tr,
              controller: controller.nameController,
              inputType: TextInputType.text,
              validationPatter: (value) => Validations.validationInputName(
                value,
                minLength: 5,
                maxLength: 50,
              ),
            ),
            DynamicDivider(height: 20),
            DynamicInput(
              label: 'claim.claim_view.form.email_label'.tr,
              controller: controller.emailController,
              inputType: TextInputType.emailAddress,
              validationPatter: Validations.validationInputEmail,
            ),
            DynamicDivider(height: 20),
            DynamicPhoneNumberInput(
              label: 'claim.claim_view.form.phone_label'.tr,
              phoneCode: controller.phoneCode,
              phoneCodeCtrl: controller.phoneLiteralController,
              phoneNumberCtrl: controller.phoneNumberController,

              inputStyle: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            DynamicDivider(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => DynamicDropdownInput(
                    label: 'claim.claim_view.form.claim_category'.tr,
                    items: controller.claimCategories.map((category) {
                      return DropdownItem(
                        value: category.id,
                        label: category.name,
                      );
                    }).toList(),
                    value: controller.selectedClaimCategoryId.value,
                    onChanged: (categoryId) {
                      if (categoryId != null) {
                        controller.updateSelectedCategory(categoryId);
                      }
                    },
                    validator: Validations.validationDropdown,
                    searchController: controller.claimCategorySearchController,
                    hint: 'claim.claim_view.form.claim_category_placeholder'.tr,
                    searchable: true,
                    dropdownSearchInputType: TextInputType.text,
                  ),
                ),

                Obx(() {
                  if (controller.selectedClaimCategoryId.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final selectedCategory = controller.claimCategories
                      .firstWhere(
                        (cat) =>
                            cat.id == controller.selectedClaimCategoryId.value,
                        orElse: () =>
                            ClaimCategory(id: '', name: '...', details: []),
                      );
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                    child: Text(
                      selectedCategory.name,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.dark2,
                      ),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            Obx(() {
              if (controller.selectedClaimCategoryId.value.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DynamicDropdownInput(
                    isDisabled:
                        controller.selectedClaimCategoryId.value.isEmpty,
                    label: 'claim.claim_view.form.claim'.tr,
                    items: controller.filteredClaims.map((claim) {
                      return DropdownItem(value: claim.id, label: claim.name);
                    }).toList(),
                    value: controller.selectedClaimId.value,
                    onChanged: (claimId) {
                      if (claimId != null) {
                        controller.updateSelectedClaim(claimId);
                      }
                    },
                    validator: Validations.validationDropdown,
                    searchController: controller.claimSearchController,
                    hint: 'claim.claim_view.form.claim_placeholder'.tr,
                    searchable: true,
                    dropdownSearchInputType: TextInputType.text,
                  ),

                  if (controller.selectedClaimId.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                      child: Text(
                        controller.filteredClaims
                            .firstWhere(
                              (claim) =>
                                  claim.id == controller.selectedClaimId.value,
                              orElse: () => Claim(id: '', name: '...'),
                            )
                            .name,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.dark2,
                        ),
                      ),
                    ),
                ],
              );
            }),
            DynamicDivider(height: 20),

            DynamicInput(
              label: 'claim.claim_view.form.message_label'.tr,
              controller: controller.messageController,
              inputType: TextInputType.text,
              minLines: 4,
              validationPatter: (value) => Validations.validationInputText(
                value,
                minLength: 5,
                maxLength: 100,
                additionalAllowedChars: [
                  ' ',
                  '¿',
                  '?',
                  '¡',
                  '!',
                  '-',
                  '.',
                  ',',
                  '[',
                  ']',
                  '(',
                  ')',
                  '\'',
                  'á',
                  'é',
                  'í',
                  'ó',
                  'ú',
                  'Á',
                  'É',
                  'Í',
                  'Ó',
                  'Ú',
                ],
              ),
            ),

            DynamicDivider(height: 60),

            DynamicButton(
              semanticSettings: const ButtonSemantics(
                identifier: 'submit_loginForm_step1',
              ),
              disabledColor: AppColors.light2,
              onPressed: controller.validateClaimForm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'claim.claim_view.form.submit'.tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.light,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
