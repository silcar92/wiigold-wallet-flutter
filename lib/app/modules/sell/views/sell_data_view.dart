import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? THEMES & IMAGES

//? WIDGETS
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';

//? OTHERS
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_progress_indicator.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/sell/controllers/sell_controller.dart';
import 'package:wiigold/app/modules/sell/widgets/sell_appbar_title.dart';
import 'package:wiigold/theme/Colors.dart';

class SellDataView extends GetView<SellController> {
  const SellDataView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: SellAppbarTitle(),
      ),
      body: SellDataPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class SellDataPage extends StatelessWidget {
  const SellDataPage({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? TITLE
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 0.9),
            children: [TextSpan(text: 'sell.sell_data_view.title'.tr)],
          ),
        ),

        DynamicDivider(height: 20),

        DynamicProgressIndicator(
          percent: 1,
          label: 'sell.sell_data_view.progress_label'.tr,
        ),

        DynamicDivider(height: 60),

        //? FORM
        SellDataFormCore(),
      ],
    );
  }
}

class SellDataFormCore extends GetView<SellController> {
  const SellDataFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: 'sellForm_step2'),
      formKey: controller.sellDataFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicInput(
            semanticSettings: InputSemantics(
              identifier: 'accountName_sellForm_step2',
            ),
            label: 'sell.sell_data_view.form.account_holder_name_label'.tr,

            controller: controller.accountNameController,
            inputType: TextInputType.text,
            validationPatter: (value) => Validations.validationInputName(
              trimWhitespace: true,
              value,
              minLength: 0,
              maxLength: 50,
            ),
          ),

          DynamicDivider(height: 20),

          Obx(
            () => DynamicDropdownInput(
              dropdownSearchInputType: TextInputType.text,
              semanticSettings: DropdownSemantics(
                identifier: 'typeDocument_sellForm_step2',
              ),
              label: 'sell.sell_data_view.form.document_type_label'.tr,


              items: [
                DropdownItem(
                  value: "DNI",
                  label: 'sell.sell_data_view.form.document_type_dni'.tr,
                ),

                DropdownItem(
                  value: "PASSPORT",
                  label: 'sell.sell_data_view.form.document_type_passport'.tr,
                ),

                DropdownItem(
                  value: "DRIVING_LICENSE",
                  label:
                      'sell.sell_data_view.form.document_type_drivers_license'
                          .tr,
                ),
              ],
              value: controller.typeDocument.value,
              onChanged: (selectedId) {
                controller.updateSelectedTypeDocument("$selectedId");
              },
              searchable: false,
              showIcons: true,
            ),
          ),

          DynamicDivider(height: 20),

          DynamicInput(
            semanticSettings: InputSemantics(
              identifier: 'nroDocument_sellForm_step2',
            ),
            label: 'sell.sell_data_view.form.document_number_label'.tr,

            controller: controller.nroDocumentController,
            inputType: TextInputType.text,
            validationPatter: (value) => Validations.validationInputText(
              value,
              minLength: 5,
              maxLength: 12,
            ),
          ),

          DynamicDivider(height: 20),

          DynamicInput(
            semanticSettings: InputSemantics(
              identifier: 'accountNumber_sellForm_step2',
            ),
            label: 'sell.sell_data_view.form.bank_account_number_label'.tr,

            controller: controller.accountNumberController,
            inputType: TextInputType.number,
            validationPatter: (value) => Validations.validationInputNumericText(
              value,
              minLength: 5,
              maxLength: 15,
            ),
          ),

          DynamicDivider(height: 20),

          Obx(() {
            if (controller.bankName.value != '') {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DynamicInput(
                    semanticSettings: InputSemantics(
                      identifier: 'bankName_sellForm_step2',
                    ),
                    label: 'sell.sell_data_view.form.bank_name_label'.tr,

                    controller: controller.bankNameController,
                    inputType: TextInputType.text,
                    validationPatter: Validations.validationInputText,
                    isDisabled: true,
                  ),
                  DynamicDivider(height: 20),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          }),

          DynamicInput(
            semanticSettings: InputSemantics(
              identifier: 'swiftCode_sellForm_step2',
            ),
            label: 'sell.sell_data_view.form.swift_code_label'.tr,

            controller: controller.swiftCodeController,
            inputType: TextInputType.text,
            validationPatter: (value) => Validations.validateSwiftCode(value),
            onChanged: (value) => controller.changeSwiftCode(value),
          ),

          DynamicDivider(height: 60),

          DynamicButton(
            onPressed: controller.validateDataSellForm,
            baseColor: AppColors.main,
            isGradient: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'sell.sell_data_view.form.submit_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
              ],
            ),
          ),

          DynamicDivider(height: 10),

          DynamicButton(
            onPressed: () {
              Get.back();
            },
            baseColor: AppColors.transparent,
            borderColor: AppColors.main,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Icon(Icons.arrow_back, color: AppColors.main),
                Text(
                  'sell.sell_data_view.form.back_button'.tr,
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
