import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//? GetX
import 'package:get/get.dart';

import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/financial/controller/financial_controller.dart';
import 'package:wiigold/app/core/services/location/controllers/location_controller.dart';
import 'package:wiigold/app/data/models/entities/locations_model.dart';
import 'package:wiigold/app/data/models/request/auth_models.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/services/navigation_persistence_service.dart';
import 'package:wiigold/app/data/storage/token_storage.dart';
import 'package:wiigold/app/modules/auth/repositories/auth_repository.dart';
import 'package:wiigold/app/modules/home/controllers/home_controller.dart';
import 'package:wiigold/app/modules/profile/controllers/profile_controller.dart';
import 'package:wiigold/app/routers/app_routes.dart';

//? KYC provider — SumSub
import 'package:veriff_flutter/veriff_flutter.dart';

//? REPOSITORY

//? STORAGE

//? MODELS

//? THEME & IMAGES

//? WIDGETS

//? MIXINS

//? Others

class AuthController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: 'AuthController');

  final TokenStorage _tokenStorage = TokenStorage();

  final AuthRepository _authRepository = AuthRepository();
  final LocationController _locationController = Get.find();

  late TextTheme textTheme;

  final RxString verificationError = ''.obs;
  final RxString verificationErrorCode = ''.obs;

  final authFormKey = GlobalKey<FormState>();

  RxList<Country> get countries => _locationController.countries;

  RxList<Region> get regions => _locationController.regions;

  final RxString selectedCountryId = RxString('');
  final RxString selectedRegionId = RxString('');

  final TextEditingController countryController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  RxBool initVerification = false.obs;

  @override
  void onReady() {
    super.onReady();

    initialCharge();

    textTheme = Theme.of(Get.context!).textTheme;
  }

  Future<void> initialCharge() async {
    showLoading(context: Get.context);

    if (countries.isEmpty) {
      logger.log(label: 'load countries');

      await _locationController.initializeCountries();
    }

    dismissLoading(context: Get.context);
  }

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

  void validateAuthForm() {
    showLoading(context: Get.context!, showLoader: true);

    if (authFormKey.currentState!.validate() && selectedRegionId.value != '') {
      initVerification.value = true;
      _submitLoginAuth();
    } else {
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );

      dismissLoading();
    }
  }

  //? KYC step
  void kycVerification() async {
    try {
      final ResponseApi res = await _authRepository.getSessionUrl();

      if (res.status == 'error') {
        dismissLoading();

        initVerification.value = false;

        switch (res.message_code) {
          case 'VERIFF_ATTEMPTS_EXCEEDED':
            verificationErrorCode.value = res.message_code!;
            verificationError.value = res.message;
            break;
        }

        return;
      }

      final String sessionUrl = res.data['verification_url'];

      if (sessionUrl ==
          'https://mock.veriff.com/v/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NDQ5MjUzMDQsInNlc3Npb25faWQiOiJiMDVjZTYyYi0yM2NmLTRmMzAtODlmZC1jMjg5NTQ0YzQ1MTciLCJpaWQiOiJlOGRhZTQ5Mi1iZWQ4LTRjMWUtYWVjZS1iNWY3OTk4ZWRlZWMiLCJ2aWQiOiIzMzNhM2Y3NC0yNWVlLTRkNmYtOTVkZC1lNjg3N2E4ZDFiNWQiLCJjaWQiOiJzYWFzLTMifQ.ry-4iekrOGYXhdG_vCgfk2IjzJe_DW_A7zsN17KFKtY') {
        _toHome();

        return;
      }

      final result = await Veriff().start(
        Configuration(
          sessionUrl,
          useCustomIntroScreen: true,
          languageLocale: "es",
        ),
      );

      switch (result.status) {
        case Status.done:
          _toHome();
          break;
        case Status.canceled:
          dismissLoading();

          DynamicToast.error(
            title: "¡Verificación cancelada!",
            description: "El usuario canceló la verificación.",
          );

          initVerification.value = false;

          break;
        case Status.error:
          String errorMessage;
          switch (result.error) {
            case Error.cameraUnavailable:
              errorMessage = "Cámara no disponible.";
              break;
            case Error.microphoneUnavailable:
              errorMessage = "Micrófono no disponible.";
              break;
            case Error.networkError:
              errorMessage = "Error de red.";
              break;
            case Error.sessionError:
              errorMessage = "Error en la sesión.";
              break;
            case Error.deprecatedSDKVersion:
              errorMessage = "Versión del SDK obsoleta.";
              break;
            case Error.nfcError:
              errorMessage = "Error al usar NFC.";
              break;
            case Error.setupError:
              errorMessage = "Error de configuración.";
              break;
            case Error.unknown:
            case Error.none:
            default:
              errorMessage = "Error desconocido.";
              break;
          }
          DynamicToast.error(
            title: "¡Ocurrió un error!",
            description: "$errorMessage",
          );

          dismissLoading();
          break;
      }
    } on PlatformException catch (e) {
      DynamicToast.error(
        title: "¡Ocurrió un error!",
        description: "Error de plataforma: ${e.message}",
      );
    } catch (e) {
      DynamicToast.error(
        title: "¡Error al iniciar la verificación!",
        description: "$e",
      );
    } finally {
      dismissLoading();
    }
  }

  void contactSupport() {}

  void retryKycVerification() {
    kycVerification();
  }

  void viewTermAndCondictions() {
    final FinancialController financialController =
        Get.find<FinancialController>();

    financialController.openTermsAndConditions();
  }

  void _submitLoginAuth() async {
    final ResponseApi res = await _authRepository.authData(
      AuthUser(
        country_id: int.parse(selectedCountryId.value),
        region_id: int.parse(selectedRegionId.value),
        address: addressController.text,
        postal_code: postalCodeController.text,
      ),
    );

    try {
      if (res.code != 200) {
        DynamicToast.error(
          title: 'form.invalidForm_title'.tr,
          description: 'form.invalidForm_error'.trParams({
            'message': res.error.toString(),
          }),
        );

        dismissLoading();

        return;
      }

      kycVerification();
    } catch (e) {
      DynamicToast.error(title: "error with _submitLoginAuth");

      dismissLoading();
    }
  }

  void _toHome() {
    final ProfileController profileController = Get.find<ProfileController>();

    profileController.chargeUser();

    Future.delayed(const Duration(seconds: 1), () async {
      Get.find<HomeController>().chargeData();

      dismissLoading();

      Get.offAllNamed(AppRoutes.KYC_APPROVED);
    });
  }

  void logout() async {
    try {
      final ResponseApi res = await _authRepository.logout();
    } catch (e) {
      print("e: ${e.toString()}");

      DynamicToast.error(title: "error with logout()");
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
      if (Get.isSnackbarOpen) Get.back();

      _tokenStorage.deleteCurrentToken();

      final NavigationPersistenceService _persistenceService = Get.find();

      _persistenceService.saveLastRoute(null);

      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
