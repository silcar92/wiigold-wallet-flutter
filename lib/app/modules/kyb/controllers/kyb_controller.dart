import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/location/controllers/location_controller.dart';
import 'package:wiigold/app/modules/kyb/repositories/kyb_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

class KybController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: 'KybController');
  final KybRepository _repo = KybRepository();
  final LocationController locationController = Get.find();

  // ─── Company info ─────────────────────────────────────────────────────────
  final legalNameCtrl = TextEditingController();
  final tradingNameCtrl = TextEditingController();
  final countrySearchCtrl = TextEditingController();
  final registrationNumberCtrl = TextEditingController();
  final incorporationDateCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final companyInfoFormKey = GlobalKey<FormState>();

  final RxString selectedCountryId = ''.obs;
  final RxString selectedLegalForm = ''.obs;

  // ─── UBO list ─────────────────────────────────────────────────────────────
  final RxList<Map<String, dynamic>> uboList = <Map<String, dynamic>>[].obs;

  // ─── UBO form ─────────────────────────────────────────────────────────────
  final uboFullNameCtrl = TextEditingController();
  final uboDateOfBirthCtrl = TextEditingController();
  final uboNationalitySearchCtrl = TextEditingController();
  final uboCountryOfResidenceSearchCtrl = TextEditingController();
  final uboOwnershipCtrl = TextEditingController();
  final uboIdNumberCtrl = TextEditingController();
  final uboFormKey = GlobalKey<FormState>();

  final RxString selectedUboNationalityId = ''.obs;
  final RxString selectedUboCountryOfResidenceId = ''.obs;
  final RxString uboIdType = ''.obs;
  final Rx<PlatformFile?> uboIdFile = Rx<PlatformFile?>(null);
  final Rx<PlatformFile?> uboAddressProof = Rx<PlatformFile?>(null);

  // ─── Documents ────────────────────────────────────────────────────────────
  final RxList<Map<String, dynamic>> uploadedDocs = <Map<String, dynamic>>[].obs;

  static const List<String> requiredDocTypes = [
    'certificate',
    'address_proof',
    'tax_registry',
    'statutes',
    'appointment',
    'shareholders',
  ];

  static const Map<String, String> docTypeLabels = {
    'certificate': 'Acta de constitución',
    'address_proof': 'Comprobante de domicilio',
    'tax_registry': 'Registro fiscal (NIT/RUT)',
    'statutes': 'Estatutos sociales',
    'appointment': 'Nombramiento representante legal',
    'shareholders': 'Registro de accionistas',
  };

  // ─── KYB status ───────────────────────────────────────────────────────────
  final RxString kybStep = ''.obs;
  final RxString kybStatus = ''.obs;
  final RxString declineReason = ''.obs;

  @override
  void onClose() {
    legalNameCtrl.dispose();
    tradingNameCtrl.dispose();
    countrySearchCtrl.dispose();
    registrationNumberCtrl.dispose();
    incorporationDateCtrl.dispose();
    addressCtrl.dispose();
    uboFullNameCtrl.dispose();
    uboDateOfBirthCtrl.dispose();
    uboNationalitySearchCtrl.dispose();
    uboCountryOfResidenceSearchCtrl.dispose();
    uboOwnershipCtrl.dispose();
    uboIdNumberCtrl.dispose();
    super.onClose();
  }

  // ─── Company info ──────────────────────────────────────────────────────────

  Future<void> submitCompanyInfo() async {
    if (!companyInfoFormKey.currentState!.validate()) return;
    if (selectedCountryId.value.isEmpty) {
      DynamicToast.error(title: 'Selecciona el país de constitución.');
      return;
    }
    if (selectedLegalForm.value.isEmpty) {
      DynamicToast.error(title: 'Selecciona el tipo societario.');
      return;
    }

    showLoading();
    try {
      final res = await _repo.saveCompanyInfo({
        'legal_name': legalNameCtrl.text.trim(),
        'trading_name': tradingNameCtrl.text.trim(),
        'country_id': int.parse(selectedCountryId.value),
        'registration_number': registrationNumberCtrl.text.trim(),
        'incorporation_date': incorporationDateCtrl.text.trim(),
        'legal_form': selectedLegalForm.value,
        'registered_address': addressCtrl.text.trim(),
        'industry': '-',
      });

      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? 'Error al guardar.');
        return;
      }
      Get.offNamed(AppRoutes.KYB_UBO_LIST);
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'submitCompanyInfo');
    } finally {
      dismissLoading();
    }
  }

  // ─── UBO list ──────────────────────────────────────────────────────────────

  Future<void> loadUboList() async {
    showLoading();
    try {
      final res = await _repo.getUboList();
      if (res.status == 'success' && res.data is List) {
        uboList.value = List<Map<String, dynamic>>.from(res.data as List);
      }
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'loadUboList');
    } finally {
      dismissLoading();
    }
  }

  Future<void> deleteUbo(int uboId) async {
    showLoading();
    try {
      final res = await _repo.deleteUbo(uboId);
      if (res.status == 'success') {
        uboList.removeWhere((u) => u['id'] == uboId);
      } else {
        DynamicToast.error(title: res.message ?? 'No se pudo eliminar.');
      }
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'deleteUbo');
    } finally {
      dismissLoading();
    }
  }

  Future<void> completeUboStep() async {
    if (uboList.isEmpty) {
      DynamicToast.error(title: 'Agrega al menos un beneficiario final.');
      return;
    }
    showLoading();
    try {
      final res = await _repo.completeUbo();
      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? 'Error al continuar.');
        return;
      }
      Get.offNamed(AppRoutes.KYB_DOCUMENTS);
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'completeUboStep');
    } finally {
      dismissLoading();
    }
  }

  // ─── UBO form ──────────────────────────────────────────────────────────────

  void clearUboForm() {
    uboFullNameCtrl.clear();
    uboDateOfBirthCtrl.clear();
    uboOwnershipCtrl.clear();
    uboIdNumberCtrl.clear();
    selectedUboNationalityId.value = '';
    selectedUboCountryOfResidenceId.value = '';
    uboIdType.value = '';
    uboIdFile.value = null;
    uboAddressProof.value = null;
  }

  Future<void> submitUboForm() async {
    if (!uboFormKey.currentState!.validate()) return;
    if (selectedUboNationalityId.value.isEmpty) {
      DynamicToast.error(title: 'Selecciona la nacionalidad.');
      return;
    }
    if (selectedUboCountryOfResidenceId.value.isEmpty) {
      DynamicToast.error(title: 'Selecciona el país de residencia.');
      return;
    }
    if (uboIdType.value.isEmpty) {
      DynamicToast.error(title: 'Selecciona el tipo de documento.');
      return;
    }
    if (uboIdFile.value == null || uboAddressProof.value == null) {
      DynamicToast.error(title: 'Sube el documento de identidad y el comprobante de domicilio.');
      return;
    }

    showLoading();
    try {
      final res = await _repo.createUbo(
        fields: {
          'full_name': uboFullNameCtrl.text.trim(),
          'date_of_birth': uboDateOfBirthCtrl.text.trim(),
          'nationality_id': int.parse(selectedUboNationalityId.value).toString(),
          'country_of_residence_id': int.parse(selectedUboCountryOfResidenceId.value).toString(),
          'ownership_percentage': uboOwnershipCtrl.text.trim(),
          'id_type': uboIdType.value,
          'id_number': uboIdNumberCtrl.text.trim(),
        },
        idFile: uboIdFile.value!,
        addressProof: uboAddressProof.value!,
      );

      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? 'Error al guardar beneficiario.');
        return;
      }
      clearUboForm();
      Get.offNamed(AppRoutes.KYB_UBO_LIST);
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'submitUboForm');
    } finally {
      dismissLoading();
    }
  }

  // ─── Documents ─────────────────────────────────────────────────────────────

  Future<void> loadDocuments() async {
    showLoading();
    try {
      final res = await _repo.getDocuments();
      if (res.status == 'success' && res.data is List) {
        uploadedDocs.value = List<Map<String, dynamic>>.from(res.data as List);
      }
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'loadDocuments');
    } finally {
      dismissLoading();
    }
  }

  bool isDocUploaded(String docType) {
    return uploadedDocs.any((d) => d['doc_type'] == docType);
  }

  int? getDocId(String docType) {
    final doc = uploadedDocs.cast<Map<String, dynamic>?>().firstWhere(
      (d) => d?['doc_type'] == docType,
      orElse: () => null,
    );
    return doc?['id'] as int?;
  }

  Future<void> uploadDocument(String docType) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
      withReadStream: false,
    );
    if (result == null || result.files.isEmpty) return;

    showLoading();
    try {
      final res = await _repo.uploadDocument(
        docType: docType,
        file: result.files.first,
      );
      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? 'Error al subir documento.');
        return;
      }
      await loadDocuments();
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'uploadDocument');
    } finally {
      dismissLoading();
    }
  }

  Future<void> deleteDocument(int docId) async {
    showLoading();
    try {
      final res = await _repo.deleteDocument(docId);
      if (res.status == 'success') {
        uploadedDocs.removeWhere((d) => d['id'] == docId);
      } else {
        DynamicToast.error(title: res.message ?? 'No se pudo eliminar.');
      }
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'deleteDocument');
    } finally {
      dismissLoading();
    }
  }

  Future<void> submitForReview() async {
    final allUploaded = requiredDocTypes.every(isDocUploaded);
    if (!allUploaded) {
      DynamicToast.error(title: 'Sube todos los documentos requeridos antes de enviar.');
      return;
    }
    showLoading();
    try {
      final res = await _repo.submitForReview();
      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? 'Error al enviar.');
        return;
      }
      Get.offNamed(AppRoutes.KYB_PENDING);
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'submitForReview');
    } finally {
      dismissLoading();
    }
  }

  // ─── Status ────────────────────────────────────────────────────────────────

  Future<void> loadStatus() async {
    showLoading();
    try {
      final res = await _repo.getStatus();
      if (res.status == 'success' && res.data is Map) {
        final data = Map<String, dynamic>.from(res.data as Map);
        kybStep.value = data['kyb_step'] as String? ?? '';
        kybStatus.value = data['kyb_status'] as String? ?? '';
        declineReason.value = data['decline_reason'] as String? ?? '';
      }
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'loadStatus');
    } finally {
      dismissLoading();
    }
  }

  Future<void> resubmit() async {
    showLoading();
    try {
      final res = await _repo.resubmit();
      if (res.status == 'error') {
        DynamicToast.error(title: res.message ?? 'Error al reenviar.');
        return;
      }
      Get.offNamed(AppRoutes.KYB_COMPANY_INFO);
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: 'resubmit');
    } finally {
      dismissLoading();
    }
  }

  // ─── UBO file pickers ──────────────────────────────────────────────────────

  Future<void> pickUboIdFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      uboIdFile.value = result.files.first;
    }
  }

  Future<void> pickUboAddressProof() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      uboAddressProof.value = result.files.first;
    }
  }
}
