//? PROVIDERS

//? MODELS

import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class RedeemRepository {
  final ApiProvider apiProvider = ApiProvider();

  RedeemRepository();

  Future<ResponseApi> redeemDetail(String id) async {
    return await apiProvider.genericGet("${ApiEndpoints.redeem_detail}$id");
  }

  Future<ResponseApi> redeemList() async {
    return await apiProvider.genericGet(ApiEndpoints.redeem_list);
  }

  Future<ResponseApi> getCalculate(Map<String, dynamic> data) async {
    return await apiProvider.genericPost(ApiEndpoints.redeem_calculate, data);
  }

  Future<ResponseApi> setDecision(String ref, Map<String, dynamic> data) async {
    return await apiProvider.genericPost(
      "${ApiEndpoints.redeem_decision}${ref}/decision/",
      data,
    );
  }

  Future<ResponseApi> getTerms() async {
    return await apiProvider.genericGet(ApiEndpoints.redeem_term);
  }

  Future<ResponseApi> setRedeem(Map<String, dynamic> data) async {
    return await apiProvider.genericPost(ApiEndpoints.redeem, data);
  }

  Future<ResponseApi> setRedeemPayment(Map<String, dynamic> data) async {
    return await apiProvider.genericPost(ApiEndpoints.redeem_payment, data);
  }
}
