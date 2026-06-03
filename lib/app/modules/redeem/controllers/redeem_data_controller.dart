import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/location/controllers/location_controller.dart';
import 'package:wiigold/app/data/models/entities/locations_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/common/widgets/layout/totp_confirm_dialog.dart';
import 'package:wiigold/app/modules/redeem/repositories/redeem_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? MIXINS

//? WIDGETS

//? Others

class RedeemDataController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RedeemController");

  final RedeemRepository _redeemRepository = RedeemRepository();

  final LocationController _locationController = Get.find();

  TextTheme textTheme = Theme.of(Get.context!).textTheme;

  //? redeem data form
  final RxString fullAddress = ''.obs;
  final RxString phoneCode = ''.obs;

  final TextEditingController phoneLiteralController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  RxList<Country> get countries => _locationController.countries;

  RxList<Region> get regions => _locationController.regions;

  final Rx<AssetBalance?> selectedToken = Rx(null);

  final RxDouble quantityToken = RxDouble(0);

  final RxString selectedCountryId = RxString('');
  final RxString selectedRegionId = RxString('');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  final redeemDataFormKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();

    _handleInitialParams();
    chargeData();
  }

  _handleInitialParams() {
    final params = Get.parameters;

    if (params['data'] != null) {
      try {
        final String jsonDataString = params['data']!;
        final dynamic data = jsonDecode(jsonDataString);

        final asset = data['asset'];

        if (asset != null) {
          selectedToken.value = AssetBalance.fromJson(asset);

          selectedToken.value = selectedToken.value;

          logger.log(
            enable: false,
            label: "selectedToken.value",
            content: selectedToken.value.toString(),
          );
        }

        final quantity = data['quantity'];

        if (asset != null) {
          quantityToken.value = quantity.toString().toDouble();
        }
      } catch (e) {
        print("e: ${e.toString()}");
      }
    }
  }

  Future<void> initialCharge() async {
    showLoading(context: Get.context);

    if (countries.isEmpty) {
      _locationController.initializeCountries();
    }

    dismissLoading(context: Get.context);
  }

  Future<void> chargeData() async {
    chargeRedeemTerms();
  }

  //? redeem data form
  void updateSelectedCountry(String value) async {
    showLoading(context: Get.context);

    selectedCountryId.value = value;
    selectedRegionId.value = '';
    regionController.clear();

    await _locationController.fetchRegionsByCountry(value);

    dismissLoading(context: Get.context);
  }

  void updateSelectedRegion(String value) {
    selectedRegionId.value = value;
    update();
  }

  Future<void> chargeRedeemTerms() async {}

  Future<void> validateRedeemDataForm() async {
    showLoading(context: Get.context!, showLoader: true);

    if (!redeemDataFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      dismissLoading();

      return;
    }

    _submitRedeemDataForm();
  }

  void _submitRedeemDataForm() async {
    final has2FA = await require2FAOrRedirect();
    if (!has2FA) return;
    await showTotpConfirmDialog(
      context: Get.context!,
      onConfirmed: () async {
        try {
          showLoading(showLoader: true);

          ResponseApi res = await _redeemRepository.setRedeem({
            "country_id": selectedCountryId.value,
            "region_id": selectedRegionId.value,
            "fullname": nameController.text,
            "address": addressController.text,
            "zip_code": postalCodeController.text,
            "phone": phoneLiteralController.text + phoneNumberController.text,
            "asset_code": selectedToken.value?.asset_code ?? '',
            "quantity": quantityToken.value,
          });

          if (res.status == 'error') {
            await logger.crashlyticsReport(
              tag: '_submitRedeemDataForm',
              reportMessage: res.message,
              customData: {
                'api_response': res.toString(),
                'api_message_code': res.message_code,
                'http_status_code': res.code,
              },
            );

            DynamicToast.error(
              title: 'form.invalidForm_title'.tr,
              description: 'form.invalidForm_error'.trParams({
                'message': res.message.toString(),
              }),
            );

            return;
          }

          Get.offAllNamed(AppRoutes.REDEEM_FINISH);
        } catch (e, s) {
          await logger.crashlyticsError(error: e, stackTrace: s, tag: 'setRedeem');
        } finally {
          dismissLoading();
        }
      },
    );
  }
}
