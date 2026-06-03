import 'dart:convert';

import 'package:flutter/material.dart';

//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/directory/success.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_dialog.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/drawer/controllers/drawer_menu_controller.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/app/core/services/location/controllers/location_controller.dart';
import 'package:wiigold/app/data/models/entities/locations_model.dart';
import 'package:wiigold/app/data/models/entities/user_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/modules/profile/repositories/profile_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? REPOSITORY

//? CONTROLLERS

//? MIXINS

//? MODELS

//? THEME & IMAGES

//? WIDGETS

class ProfileController extends GetxController with LoadingMixin {
  Logger logger = Logger(module: "ProfileController");

  late TextTheme textTheme;

  final ProfileRepository _profileRepository = ProfileRepository();
  final LocationController _locationController = Get.find();

  final drawerController = Get.put(DrawerMenuController());

  Rx<User?> currentUser = Rx<User?>(null);
  RxString kycProviderStatus = ''.obs;
  RxString complianceStatus = ''.obs;

  final dataFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  //? PHONE
  final RxString phoneCode = ''.obs;
  final TextEditingController phoneLiteralController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final RxString selectedCountryId = RxString('');
  final RxString selectedRegionId = RxString('');

  final TextEditingController countryController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  final RxString fullAddress = ''.obs;

  RxList<Country> get countries => _locationController.countries;

  RxList<Region> get regions => _locationController.regions;

  RxBool onChangeEmail = false.obs;
  RxBool onChangePhone = false.obs;
  RxBool onChangeAddress = false.obs;
  RxBool onChangePassword = false.obs;
  RxBool acceptTerms = false.obs;

  RxBool inInputPassword = false.obs;
  RxString inputPasswordMode = ''.obs;
  final TextEditingController passwordController = TextEditingController();
  final inputPasswordFormKey = GlobalKey<FormState>();

  //? kyc view
  static const _complianceStatesForVerification = {'300', '310'};
  static const _kycProviderStatesForVerification = {'100', '110', '120'};

  bool get shouldShowVerificationButton {
    final user = currentUser.value;
    if (user == null ||
        user.compliance_status == null ||
        user.kyc_provider_status == null) {
      return false;
    }
    final needsComplianceVerification = _complianceStatesForVerification
        .contains(user.compliance_status);
    final needsKycVerification = _kycProviderStatesForVerification.contains(
      user.kyc_provider_status,
    );
    return needsComplianceVerification || needsKycVerification;
  }

  @override
  void onReady() {
    super.onReady();
    textTheme = Theme.of(Get.context!).textTheme;
  }

  Future<void> synceProfile() async {
    showLoading(context: Get.context!);

    if (countries.isEmpty) {
      await _locationController.initializeCountries();
    }

    await chargeUser();

    await _chargeForm();

    dismissLoading();
  }

  Future<void> chargeUser({bool forceRefresh = false}) async {
    try {
      final ResponseApi res = await _profileRepository.getUserProfile();

      if (res.status == 'error') {
        DynamicToast.error(title: 'profile.controller.load_profile_error'.tr);
        return;
      }

      final user = res.data;

      currentUser.value = User(
        first_name: user['first_name'],
        last_name: user['last_name'],
        email: user['email'],
        phone_literal: user['phone_literal'],
        phone_number: user['phone_number'],
        country_id: user['country_id'],
        region_id: user['region_id'],
        address: user['address'],
        postal_code: user['postal_code'],
        date_of_birth: user['date_of_birth'],
        identification_number: user['identification_number'],
        wallet_address: user['wallet_address'],
        kyc_provider_status:
            "${user['identity_verification']['status']['code']}",
        compliance_status: "${user['compliance_status']['code']}",
        person_type: user['person_type'] as String?,
        kyb_step: user['kyb_step'] as String?,
        kyb_status: user['kyb_status'] as String?,
        company_trading_name: user['company_trading_name'] as String?,
        company_legal_name: user['company_legal_name'] as String?,
      );
    } catch (e) {
      print("ProfileController: Error en chargeUser: ${e.toString()}");
    }
  }

  String getStatus(String status) {
    return {
          "100": 'profile.controller.status_not_started'.tr,
          "110": 'profile.controller.status_started'.tr,
          "120": 'profile.controller.status_in_process'.tr,
          "130": 'profile.controller.status_approved'.tr,
          "140": 'profile.controller.status_manual_review'.tr,
          "150": 'profile.controller.status_rejected'.tr,
          "160": 'profile.controller.status_resubmission_required'.tr,
          "200": 'profile.controller.status_not_started'.tr,
          "210": 'profile.controller.status_started'.tr,
          "220": 'profile.controller.status_in_process'.tr,
          "230": 'profile.controller.status_approved'.tr,
          "240": 'profile.controller.status_manual_review'.tr,
          "250": 'profile.controller.status_rejected'.tr,
          "300": 'profile.controller.status_not_started'.tr,
          "310": 'profile.controller.status_pending_identity_verification'.tr,
          "320": 'profile.controller.status_pending_watchlist_verification'.tr,
          "330": 'profile.controller.status_manual_review'.tr,
          "340": 'profile.controller.status_approved'.tr,
          "350": 'profile.controller.status_rejected'.tr,
        }[status] ??
        'profile.controller.status_unknown'.tr;
  }

  Future<void> _chargeForm() async {
    if (currentUser.value == null) return;

    final user = currentUser.value!;
    nameController.text = "${user.first_name} ${user.last_name}";
    birthdayController.text = user.date_of_birth ?? '';
    identifierController.text = user.identification_number ?? '';
    emailController.text = user.email;
    phoneCode.value = user.phone_literal ?? '';
    phoneLiteralController.text = user.phone_literal ?? '';
    phoneNumberController.text = user.phone_number ?? '';
    addressController.text = user.address ?? '';
    postalCodeController.text = user.postal_code ?? '';

    await updateSelectedCountry(user.country_id.toString());
    updateSelectedRegion(user.region_id.toString());

    formatAddress();
    update();
  }

  void formatAddress() {
    if (currentUser.value == null || countries.isEmpty) {
      fullAddress.value = '';
      return;
    }

    final user = currentUser.value!;

    final Country? currentCountry = countries.firstWhereOrNull(
      (c) => c.id == user.country_id,
    );
    final Region? currentRegion = regions.firstWhereOrNull(
      (r) => r.id == user.region_id,
    );

    final parts = [
      user.address,
      if (user.postal_code?.isNotEmpty ?? false) "C.P. ${user.postal_code}",
      currentRegion?.name,
      currentCountry?.name,
    ];

    fullAddress.value = parts
        .where((p) => p != null && p.isNotEmpty)
        .join('. ');
  }

  Future<void> updateSelectedCountry(String value) async {
    selectedCountryId.value = value;
    await _locationController.fetchRegionsByCountry(value);
  }

  void updateSelectedRegion(String value) {
    selectedRegionId.value = value;
    update();
  }

  void resetForm() {
    onChangeEmail.value = false;
    onChangePassword.value = false;
    onChangePhone.value = false;
    onChangeAddress.value = false;
    inInputPassword.value = false;
    inputPasswordMode.value = '';
    passwordController.clear();
    _chargeForm();
  }

  Future<bool> _updateProfileData(Map<String, dynamic> data) async {
    if (!dataFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      return false;
    }
    try {
      showLoading(context: Get.context!);

      final ResponseApi res = await _profileRepository.getUpdateProfileData(
        data,
      );

      if (res.status == 'error') {
        DynamicToast.error(
          title: 'profile.controller.error_title'.tr,
          description: AppErrors.getErrorLabel(res.message),
        );
        return false;
      }

      await synceProfile();

      return true;
    } catch (e) {
      DynamicToast.error(title: 'profile.controller.update_data_error'.tr);
      return false;
    } finally {
      dismissLoading();
    }
  }

  Future<void> saveEmail() async {
    if (emailController.text.trim().isEmpty ||
        emailController.text == currentUser.value?.email)
      return;

    if (!dataFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );
      return;
    }

    DynamicDialog(
      context: Get.context!,
      title: 'profile.controller.confirm_dialog_title'.tr,
      message: 'profile.controller.confirm_dialog_password_message'.tr,
      onConfirm: () {
        Get.back();

        inInputPassword.value = true;
        inputPasswordMode.value = 'changeEmail';
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  Future<void> saveAddress() async {
    if (addressController.text.trim().isEmpty ||
        postalCodeController.text.trim().isEmpty)
      return;
    final bool editProfile = await _updateProfileData({
      "country_id": int.parse(selectedCountryId.value),
      "region_id": int.parse(selectedRegionId.value),
      "address": addressController.text,
      "postal_code": postalCodeController.text,
    });
    if (editProfile) {
      onChangeAddress.value = false;
    }
  }

  Future<void> savePhoneNumber() async {
    if (phoneNumberController.text.trim().isEmpty ||
        phoneCode.value.trim().isEmpty)
      return;
    final bool editProfile = await _updateProfileData({
      "phone_literal": phoneCode.value,
      "phone_number": phoneNumberController.text,
    });
    if (editProfile) {
      onChangePhone.value = false;
    }
  }

  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  void viewTermAndCondictions() {
    final FinancialController financialController =
        Get.find<FinancialController>();

    financialController.openTermsAndConditions();
  }

  void validateNewPasswordForm() {
    if (!inputPasswordFormKey.currentState!.validate()) {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );
      return;
    }
    switch (inputPasswordMode.value) {
      case "changeEmail":
        _changeEmail();
        break;
      case "changePassword":
        break;
    }
  }

  void _changeEmail() async {
    try {
      showLoading(context: Get.context!);

      final ResponseApi res = await _profileRepository.updateEmail({
        "new_email": emailController.text,
        "password": passwordController.text,
      });

      dismissLoading();

      if (res.status == 'error') {
        DynamicToast.error(
          title: 'profile.controller.error_title'.tr,
          description: AppErrors.getErrorLabel(res.message),
        );
        return;
      }

      onChangeEmail.value = false;
      inInputPassword.value = false;
      inputPasswordMode.value = '';

      DynamicToast.info(title: AppSuccess.getSuccessLabel(res.message));

      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      DynamicToast.error(title: 'profile.controller.change_email_error'.tr);
    } finally {
      dismissLoading();
    }
  }
}
