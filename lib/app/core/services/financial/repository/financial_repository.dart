//? MODELS

import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class FinancialRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ResponseApi> getPaymentMethods() async {
    return _apiProvider.genericGet(ApiEndpoints.payment_method_types);
  }

  Future<ResponseApi> getPaymentMethodDetails(String type) async {
    return _apiProvider.genericGet(
      "${ApiEndpoints.payment_methods}?type=${type}",
    );
  }

  Future<ResponseApi> getTermsAndConditionsDocument() async {
    return _apiProvider.genericGet(ApiEndpoints.terms_and_conditions_document);
  }

  Future<ResponseApi> getPrivacyPolicyDocument() async {
    return _apiProvider.genericGet(ApiEndpoints.privacy_policy_document);
  }
}
