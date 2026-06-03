import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/functions.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';

import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/payment_methods_list.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/loan/controllers/loan_payment_controller.dart';
import 'package:wiigold/app/modules/loan/widgets/loan_appbar_title.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/theme/Colors.dart';

class LoanPaymentInfoView extends StatelessWidget {
  const LoanPaymentInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.find<LoanPaymentController>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      scaffoldKey: scaffoldKey,
      backButtonBehavior: BackButtonBehavior.custom,
      onCustomBack: () {
        Get.offAllNamed(AppRoutes.LOAN_PAYMENT);
      },
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: true,
        title: LoanAppbarTitle(),
        backbuttomFunction: () {
          Get.offAllNamed(AppRoutes.LOAN_PAYMENT);
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      isContentCentered: true,
      body: LoanPaymentInfoPage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.send,
      ),
    );
  }
}

class LoanPaymentInfoPage extends GetView<LoanPaymentController> {
  const LoanPaymentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textTheme.displayMedium?.copyWith(
                  height: 1.1,
                  fontSize: 38,
                ),
                children: [
                  TextSpan(
                    text: 'loan.payment_view.method_form.payment_methods_label'
                        .tr,
                  ),
                ],
              ),
            ),

            Obx(
              () => DynamicDropdownInput(
                label: '',
                items: controller.availablePaymentMethods
                    .map(
                      (p) => DropdownItem(
                        value: p.id,
                        label: p.name,
                        icon: buildAssetImage(p.iconUrl ?? ''),
                      ),
                    )
                    .toList(),
                value: controller.selectedPaymentMethodId.value,
                onChanged: (paymentMethodId) =>
                    controller.getPaymentMethodDetails(paymentMethodId!),

                validator: Validations.validationDropdown,
                dropdownSearchInputType: TextInputType.text,
                showIcons: true,
              ),
            ),

            DynamicDivider(height: 20),

            PaymentMethodsList(
              paymentMethods: controller.availablePaymentMethodsDetail,
            ),

            DynamicDivider(height: 20),

            DynamicButton(
              baseColor: AppColors.main,
              isGradient: true,
              onPressed: () => {Get.toNamed(AppRoutes.LOAN_PAYMENT_DATA)},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 8,
                children: [
                  Text(
                    'loan.loan_payment_info.pay_button'.tr,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.light,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
