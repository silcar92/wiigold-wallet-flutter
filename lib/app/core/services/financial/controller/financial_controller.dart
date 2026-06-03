import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/financial/repository/financial_repository.dart';
import 'package:wiigold/app/data/models/entities/payment_methods_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/routers/app_routes.dart';

class FinancialController extends GetxController with LoadingMixin {
  final FinancialRepository _financialRepository = FinancialRepository();

  final RxList<PaymentMethodType> paymentMethods = <PaymentMethodType>[].obs;
  final RxList<PaymentMethod> paymentMethodDetails = <PaymentMethod>[].obs;

  final RxBool _hasPaymentMethodsLoaded = false.obs;

  Future<void> initializePaymentMethods() async {
    if (_hasPaymentMethodsLoaded.value) return;

    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _financialRepository.getPaymentMethods();

      if (res.code == 200) {
        final List<dynamic> rawDataList = res.data as List<dynamic>;

        final List<PaymentMethodType> loadedPaymentMethods = rawDataList
            .whereType<Map<String, dynamic>>()
            .map((jsonMap) => PaymentMethodType.fromJson(jsonMap))
            .toList();

        paymentMethods.assignAll(loadedPaymentMethods);

        _hasPaymentMethodsLoaded.value = true;
      } else {
        paymentMethods.clear();
      }
    } catch (e) {
      paymentMethods.clear();
    } finally {
      dismissLoading();
    }
  }

  Future<void> fetchPaymentMethodDetailsByPaymentMethod(String id) async {
    if (id.isEmpty) {
      paymentMethodDetails.clear();

      return;
    }

    showLoading(context: Get.context!);

    paymentMethodDetails.clear();

    try {
      final ResponseApi res = await _financialRepository
          .getPaymentMethodDetails(id);

      if (res.code == 200 || res.status == 'success') {
        final List<dynamic> rawDataList = res.data as List<dynamic>;

        final List<PaymentMethod> loadedPaymentMethodDetails = rawDataList
            .whereType<Map<String, dynamic>>()
            .map((jsonMap) => PaymentMethod.fromJson(jsonMap))
            .toList();
        paymentMethodDetails.assignAll(loadedPaymentMethodDetails);
      } else {
        paymentMethodDetails.clear();
      }
    } catch (e) {
      paymentMethodDetails.clear();
    } finally {
      dismissLoading();
    }
  }

  Future<void> openPrivacyPolicy() async {
    showLoading(context: Get.context!);
    try {
      final ResponseApi res = await _financialRepository
          .getPrivacyPolicyDocument();

      if (res.code == 200 && res.data != null && res.data['url'] != null) {
        dismissLoading();
        Get.toNamed(
          AppRoutes.DOCUMENT_VIEWER,
          arguments: {
            'url': res.data['url'] as String,
            'title': 'document_viewer.privacy_title'.tr,
          },
        );
      } else {
        DynamicToast.error(title: 'widgets.term_and_conditions.failed'.tr);
        dismissLoading();
      }
    } catch (e) {
      print("FinancialController: Error al abrir política de privacidad: $e");
      DynamicToast.error(title: 'loan.request_controller.unexpected_error'.tr);
      dismissLoading();
    }
  }

  Future<void> openTermsAndConditions() async {
    showLoading(context: Get.context!);
    try {
      final ResponseApi res = await _financialRepository
          .getTermsAndConditionsDocument();

      if (res.code == 200 && res.data != null && res.data['url'] != null) {
        dismissLoading();
        Get.toNamed(
          AppRoutes.DOCUMENT_VIEWER,
          arguments: {
            'url': res.data['url'] as String,
            'title': 'document_viewer.tos_title'.tr,
          },
        );
      } else {
        DynamicToast.error(title: 'widgets.term_and_conditions.failed'.tr);
        dismissLoading();
      }
    } catch (e) {
      print("FinancialController: Error al abrir términos y condiciones: $e");
      DynamicToast.error(title: 'loan.request_controller.unexpected_error'.tr);
      dismissLoading();
    }
  }
}
