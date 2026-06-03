import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/data/models/entities/claim_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/modules/claim/respositories/claim_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

class ClaimController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "ClaimController");
  final ClaimRepository _claimRepository = ClaimRepository();
  final claimFormKey = GlobalKey<FormState>();

  final RxList<ClaimCategory> claimCategories = <ClaimCategory>[].obs;
  final RxList<Claim> filteredClaims = <Claim>[].obs;

  final RxString selectedClaimCategoryId = RxString('');
  final TextEditingController claimCategorySearchController =
      TextEditingController();

  final RxString selectedClaimId = RxString('');
  final TextEditingController claimSearchController = TextEditingController();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneCode = ''.obs;
  final TextEditingController phoneLiteralController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchClaimCategoriesAndDetails();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneLiteralController.dispose();
    phoneNumberController.dispose();
    messageController.dispose();
    claimCategorySearchController.dispose();
    claimSearchController.dispose();
    super.onClose();
  }

  Future<void> fetchClaimCategoriesAndDetails() async {
    showLoading(context: Get.context!);
    try {
      final ResponseApi res = await _claimRepository
          .getClaimCategoriesWithDetails();
      if (res.code == 200) {
        final List<dynamic> rawData = res.data as List<dynamic>;
        final List<ClaimCategory> loadedData = rawData
            .map((json) => ClaimCategory.fromJson(json as Map<String, dynamic>))
            .toList();
        claimCategories.assignAll(loadedData);
      } else {
        claimCategories.clear();
        DynamicToast.error(
          title: 'Error',
          description: res.message ?? 'No se pudieron cargar las categorías.',
        );
      }
    } catch (e, s) {
      claimCategories.clear();
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'fetchClaimData',
        reason: 'Falló al obtener los datos de reclamo.',
      );
      DynamicToast.error(
        title: 'Error',
        description: 'Ocurrió un error inesperado.',
      );
    } finally {
      dismissLoading();
    }
  }

  void updateSelectedCategory(String categoryId) {
    selectedClaimCategoryId.value = categoryId;
    selectedClaimId.value = '';
    claimSearchController.clear();

    final selectedCategory = claimCategories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => ClaimCategory(id: '', name: '', details: []),
    );

    filteredClaims.assignAll(selectedCategory.details);
  }

  void updateSelectedClaim(String claimId) {
    selectedClaimId.value = claimId;
  }

  void clearAllForms() {
    nameController.clear();
    emailController.clear();
    phoneLiteralController.clear();
    phoneNumberController.clear();
    messageController.clear();
    claimCategorySearchController.clear();
    claimSearchController.clear();

    selectedClaimCategoryId.value = '';
    selectedClaimId.value = '';
    filteredClaims.clear();
    phoneCode.value = '';

    claimFormKey.currentState?.reset();
  }

  void validateClaimForm() async {
    showLoading(context: Get.context!, showLoader: true);

    if (!claimFormKey.currentState!.validate()) {
      dismissLoading();
      DynamicToast.error(
        title: 'form.invalidForm_title'.tr,
        description: 'form.invalidForm_message'.tr,
      );
      return;
    }

    try {
      final Map<String, dynamic> claimData = {
        'name': nameController.text,
        'email': emailController.text.toLowerCase(),
        'phone': '${phoneCode.value}${phoneNumberController.text}',
        'claim_category': selectedClaimCategoryId.value,
        'claim_detail': selectedClaimId.value,
        "message": messageController.text,
      };

      final ResponseApi res = await _claimRepository.createClaim(claimData);

      dismissLoading();

      if (res.status == 'success') {
        await Future.delayed(const Duration(milliseconds: 50));

        Get.back();

        await Future.delayed(const Duration(milliseconds: 50));

        DynamicToast.success(
          title: 'claim.claim_view.success_title'.tr,
          description: 'claim.claim_view.success_message'.tr,
        );
      } else {
        await logger.crashlyticsReport(
          tag: 'createClaimFailure',
          reportMessage: res.message ?? 'Error response from API',
          customData: {
            'api_response': res.toString(),
            'http_status_code': res.code,
            'request_data': claimData.toString(),
          },
        );

        DynamicToast.error(
          title: 'Error',
          description: res.message ?? 'Ocurrió un error al enviar el reclamo.',
        );
      }
    } catch (e, s) {
      dismissLoading();

      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'createClaimException',
        reason: 'Excepción al intentar crear un reclamo.',
        customData: {'email_attempt': emailController.text},
      );

      DynamicToast.error(
        title: 'Error',
        description: 'Ocurrió un error inesperado.',
      );
    }
  }
}
