import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:wiigold/app/common/widgets/form/dynamic_clipboard_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_qrscanner.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_bottom_navigation.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_divider.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/send/controllers/send_controller.dart';
import 'package:wiigold/app/modules/send/widgets/send_appbar_title.dart';
import 'package:wiigold/theme/Colors.dart';

class SendInsertTargetView extends StatelessWidget {
  const SendInsertTargetView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.find<SendController>();

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(showLogo: false, title: SendAppbarTitle()),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      isContentCentered: true,
      body: SendInsertTargetPage(),
      bottomNavigationBar: DynamicBottomNavigation(
        currentTab: BottomNavTab.send,
      ),
    );
  }
}

class SendInsertTargetPage extends GetView<SendController> {
  const SendInsertTargetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: DynamicForm(
        formKey: controller.targetSendFormKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => controller.isScanning.value
                  ? SizedBox()
                  : RichText(
                      text: TextSpan(
                        style: textTheme.displayMedium?.copyWith(
                          height: 1.1,
                          fontSize: 38,
                        ),
                        children: [
                          TextSpan(
                            text: 'send.insert_target_view.title_part1'.tr,
                          ),
                          TextSpan(
                            text: 'send.insert_target_view.title_part2'.tr,
                          ),
                        ],
                      ),
                    ),
            ),
            DynamicDivider(height: 40),
            Obx(
              () => controller.isScanning.value
                  ? _buildQRScanner()
                  : DynamicClipboardInput(
                      label: 'send.insert_target_view.target_label'.tr,
                      controller: controller.targetController,
                      clipboardButtonText:
                          'send.insert_target_view.paste_button'.tr,
                      clipboardAction: () async {
                        ClipboardData? data = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );

                        if (data != null && data.text != null) {
                          controller.targetController.text = data.text!;
                        }
                      },
                      inputStyle: textTheme.labelLarge,
                      semanticSettings: InputSemantics(
                        identifier: 'clipboard_input',
                      ),
                      isDisabled: false,
                      onTapEnter: (value) => {
                        controller.validateInsertAddressForm(),
                      },
                    ),
            ),
            DynamicDivider(height: 50),
            Obx(
              () => DynamicButton(
                semanticSettings: ButtonSemantics(identifier: 'scan_qr_button'),
                disabledColor: AppColors.dark2,
                borderColor: AppColors.main,
                baseColor: Colors.transparent,

                onPressed: () => controller.isScanning.toggle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Icon(
                      controller.isScanning.value
                          ? Icons.arrow_back
                          : Icons.qr_code,
                      size: 20,
                      color: AppColors.main,
                    ),
                    Text(
                      controller.isScanning.value
                          ? 'send.insert_target_view.return_button'.tr
                          : 'send.insert_target_view.scan_qr_button'.tr,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.main,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DynamicDivider(height: 10),
            Obx(
              () => controller.isScanning.value
                  ? SizedBox()
                  : DynamicButton(
                      semanticSettings: ButtonSemantics(
                        identifier: 'send_insert_target_continue_button',
                      ),
                      disabledColor: AppColors.dark2,
                      isGradient: true,
                      baseColor: AppColors.main,
                      onPressed: controller.validateInsertAddressForm,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        spacing: 8,
                        children: [
                          Text(
                            'send.insert_target_view.continue_button'.tr,
                            style: textTheme.titleLarge?.copyWith(
                              color: AppColors.light,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: AppColors.light,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRScanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DynamicQRScanner(
          width: 300,
          height: 300,
          onDetect: controller.onDetect,
        ),
      ],
    );
  }
}
