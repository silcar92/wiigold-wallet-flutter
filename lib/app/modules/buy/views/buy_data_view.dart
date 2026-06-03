import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? THEMES & IMAGES

//? WIDGETS
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_image_picker.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_progress_indicator.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_show_payment_method_info.dart';
import 'package:wiigold/app/core/services/drawer/views/drawer_menu_view.dart';
import 'package:wiigold/app/modules/buy/controllers/buy_controller.dart';
import 'package:wiigold/app/modules/buy/widgets/buy_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

//? OTHERS

class BuyDataView extends GetView<BuyController> {
  const BuyDataView({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        Get.back();
      },
      appBar: DynamicAppBar(
        scaffoldKey: scaffoldKey,
        showLogo: false,
        showActions: false,
        title: BuyAppbarTitle(),
        backbuttomFunction: () {
          Get.back();
        },
      ),
      body: BuyDataPage(),
      drawer: DrawerView(scaffoldKey: scaffoldKey),
    );
  }
}

class BuyDataPage extends GetView<BuyController> {
  const BuyDataPage({super.key});

  @override
  //? ROOT WIDGET
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.displayLarge?.copyWith(height: 0.9),
            children: [
              TextSpan(text: 'buy.buy_data_view.title_part1'.tr),
              TextSpan(
                text: 'buy.buy_data_view.title_part2_highlight'.tr,
                style: TextStyle(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 20),

        DynamicProgressIndicator(
          percent: 1,
          label: "4/4",
          labelStyle: textTheme.titleLarge?.copyWith(
            color: AppColors.dark2,
            fontWeight: FontWeight.w600,
          ),
        ),

        DynamicDivider(height: 20),

        //? FORM
        BuyDataFormCore(),
      ],
    );
  }
}

class BuyDataFormCore extends GetView<BuyController> {
  const BuyDataFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      semanticSettings: FormSemantics(identifier: 'buyForm_step3'),
      formKey: controller.buyDataFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  style: textTheme.displayLarge,
                  children: [
                    TextSpan(
                      text: 'buy.buy_data_view.form.amount_to_pay_label'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          "${controller.payableAmountController.text.toHauvNumericString()} USD",
                      style: TextStyle(
                        color: AppColors.main,
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          DynamicDivider(height: 20),

          DynamicImagePickerInput(
            label: 'buy.buy_data_view.form.payment_proof_label'.tr,
            controller: controller.proofImageController,
          ),

          DynamicDivider(height: 40),

          DynamicInput(
            label: 'buy.buy_data_view.form.payment_reference_label'.tr,
            controller: controller.proofController,
            inputType: TextInputType.text,
            validationPatter: (value) => Validations.validationInputText(
              value,
              minLength: 5,
              maxLength: 20,
              additionalAllowedChars: ['-'],
            ),

            inputStyle: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          DynamicDivider(height: 60),

          DynamicButton(
            onPressed: controller.validateDataBuyForm,
            isGradient: true,
            baseColor: AppColors.main,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'buy.buy_data_view.form.submit_button'.tr,
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
                  'buy.buy_data_view.form.back_button'.tr,
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
