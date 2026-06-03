import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_numeric.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/send/controllers/send_controller.dart';
import 'package:wiigold/app/modules/send/widgets/send_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class SendView extends StatelessWidget {
  const SendView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.find<SendController>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,

      appBar: DynamicAppBar(
        showLogo: false,
        title: SendAppbarTitle(),
        backbuttomFunction: () {
          Get.back();
        },
      ),
      onRefresh: controller.chargeData,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      isContentCentered: true,
      onCustomBack: () {
        Get.back();
      },
      body: SendPage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.send,
      ),
    );
  }
}

class SendPage extends GetView<SendController> {
  const SendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: DynamicForm(
        formKey: controller.amountSendFormKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.displayMedium?.copyWith(
                  height: 1.1,
                  fontSize: 38,
                ),
                children: [
                  TextSpan(text: 'send.view.title_part1'.tr),
                  TextSpan(
                    text: 'send.view.title_part2'.tr,
                    style: TextStyle(color: AppColors.main),
                  ),
                ],
              ),
            ),
            DynamicDivider(height: 40),

            Obx(() {
              final availableBalance =
                  controller.selectedToken.value?.available?.toDouble() ?? 0.0;

              return DynamicNumeric(
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
                max: availableBalance,
                inputStyle: textTheme.displayMedium,
                onTapEnter: (value) => {controller.validateInsetAmountForm()},
                inputDecoration: InputDecoration(
                  hintText: 'send.view.amount_hint'.tr,
                  hintStyle: textTheme.displayMedium?.copyWith(
                    color: AppColors.dark3,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main, width: 2),
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
                  max: availableBalance,
                  disallowZero: true,
                ),
                onChanged: (value) {
                  controller.onAmountChanged(value);
                },
              );
            }),

            Obx(() {
              final availableBalance =
                  controller.selectedToken.value?.available?.toDouble() ?? 0.0;

              return Flex(
                direction: Axis.vertical,
                children: [
                  RichText(
                    text: TextSpan(
                      style: textTheme.labelLarge?.copyWith(
                        height: 1.1,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: 'send.view.available_balance'.tr),
                        TextSpan(
                          text: availableBalance.toHauvNumericString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.main,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            DynamicDivider(height: 40),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      'send.view.commission_message'.trParams({
                        'commission': controller.commission.value,
                        'tokenName':
                            controller.selectedToken.value?.asset_info?.name ??
                            '',
                      }),
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            DynamicDivider(height: 60),
            Obx(
              () => DynamicButton(
                semanticSettings: ButtonSemantics(
                  identifier: 'send_insert_amount_continue_button',
                ),
                isDisabled: controller.isBlocked.value == true,
                isGradient: true,
                disabledColor: AppColors.light2,
                onPressed: controller.validateInsetAmountForm,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Text(
                      'send.view.continue_button'.tr,
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
