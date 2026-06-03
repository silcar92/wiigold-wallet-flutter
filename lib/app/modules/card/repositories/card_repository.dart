import 'dart:convert';

import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';

class CardRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ResponseApi> activateVirtualCard() async {
    return _apiProvider.genericPost(ApiEndpoints.card_activate, {});
  }

  Future<ResponseApi> getCardDetails() async {
    return _apiProvider.genericGet(ApiEndpoints.card_details);
  }

  Future<ResponseApi> setCardFreezeStatus(bool freeze) async {
    return _apiProvider.genericPost(ApiEndpoints.card_freeze, {
      "freeze": freeze,
    });
  }

  Future<ResponseApi> blockCard() async {
    return _apiProvider.genericPost(ApiEndpoints.card_block, {});
  }

  Future<ResponseApi> getCardTransactions({
    int page = 1,
    int pageSize = 10,
  }) async {
    final endpoint =
        '${ApiEndpoints.card_transactions}?page=$page&page_size=$pageSize';
    return _apiProvider.genericGet(endpoint);
  }

  Future<ResponseApi> requestPhysicalCard() async {
    return _apiProvider.genericPost(ApiEndpoints.card_requestPhysical, {});
  }
}
