import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';

//? CONTROLLERS

//? VALIDATIONS

//? THEMES & IMAGES

//? WIDGETS
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/request/controllers/request_controller.dart';
import 'package:wiigold/app/modules/request/widgets/request_appbar_title.dart';
import 'package:wiigold/theme/Colors.dart';

class RequestView extends GetView<RequestController> {
  const RequestView({super.key});

  @override
  //? ROOT WIDGET
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
      appBar: DynamicAppBar(
        showLogo: false,
        title: RequestAppbarTitle(),
        backbuttomFunction: () {
          Get.back();
        },
      ),
      isContentCentered: true,
      body: RequestPage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.request,
      ),
    );
  }
}

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  //? ROOT PAGE
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.displayMedium?.copyWith(height: 1.1, fontSize: 38),
            children: [
              TextSpan(text: 'request.view.title_part1'.tr),
              TextSpan(
                text: 'request.view.title_part2'.tr,
                style: TextStyle(color: AppColors.main),
              ),
            ],
          ),
        ),

        DynamicDivider(height: 60),

        RequestFormCore(),
      ],
    );
  }
}

class RequestFormCore extends GetView<RequestController> {
  const RequestFormCore({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DynamicForm(
      formKey: controller.amountRequestFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          Obx(
            () => DynamicNumeric(
              semanticSettings: NumericSemantics(
                identifier: 'send_insert_amount_input',
              ),
              label: '',
              labelStyle: textTheme.titleMedium?.copyWith(
                color: AppColors.light,
                fontWeight: FontWeight.w600,
                height: .25,
              ),
              enableInteractiveSelection: false,
              controller: controller.amountController,
              allowDecimals: true,
              maxDecimals: 4,
              min: 0.1,
              max: 9999.9999,
              inputStyle: textTheme.displayMedium,
              inputDecoration: InputDecoration(
                hintText: 'request.view.amount_hint'.tr,
                hintStyle: textTheme.displayMedium?.copyWith(
                  color: AppColors.dark2,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.dark2, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.dark2, width: 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.dark2, width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.failure),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.failure),
                ),
                errorStyle: textTheme.bodyMedium?.copyWith(
                  height: .75,
                  fontWeight: FontWeight.w500,
                  color: AppColors.failure,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16.0,
                ),
                isDense: true,
                suffixIcon: Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  constraints: const BoxConstraints(
                    maxHeight: 40,
                    maxWidth: 48,
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      controller.selectedToken.value?.asset_info?.name ?? '',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              isDisabled: false,
              validationPatter: (value) => Validations.validationInputNumeric(
                value,
                min: 0,
                disallowZero: true,
              ),
            ),
          ),

          DynamicDivider(height: 50),

          DynamicButton(
            semanticSettings: ButtonSemantics(
              identifier: 'send_insert_amount_continue_button',
            ),
            disabledColor: AppColors.dark2,
            isGradient: true,
            onPressed: () => controller.validateRequestForm(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 8,
              children: [
                Text(
                  'request.view.continue_button'.tr,
                  style: textTheme.titleLarge?.copyWith(color: AppColors.light),
                ),
                Icon(Icons.arrow_forward, size: 20, color: AppColors.light),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
