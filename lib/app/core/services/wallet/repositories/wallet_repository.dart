//? PROVIDERS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/common/utils/validations.dart';
//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class WalletRepository {
  final ApiProvider _apiProvider = ApiProvider();

  WalletRepository();

  Future<ResponseApi> getAllBalance() async {
    return _apiProvider.genericGet(ApiEndpoints.balance);
  }

  Future<ResponseApi> getHauvBalance() async {
    return _apiProvider.genericGet("${ApiEndpoints.balance}HV_B75VRLGX_0P7R/");
  }

  Future<ResponseApi> getTokenBalance(String asset_code) async {
    return _apiProvider.genericGet("${ApiEndpoints.balance}$asset_code/");
  }

  Future<ResponseApi> getWalletUser(String target) async {
    final Map<String, dynamic> queryParams = {};

    if (Validations.validationInputEmail(target, pureValidation: true) ==
        'true') {
      queryParams.addAll({"email": target});
    } else {
      queryParams.addAll({"address": target});
    }

    return _apiProvider.genericGet(
      ApiEndpoints.get_user_wallet,
      queryParams: queryParams,
    );
  }

  Future<ResponseApi> sendTransaction(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.transaction_send, data);
  }

  Future<ResponseApi> getCommision(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.comission, data);
  }

  Future<ResponseApi> getExchangeCommision(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.exchange_comission, data);
  }

  Future<ResponseApi> excecuteExchange(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.exchange, data);
  }

  Future<ResponseApi> getSellCommision(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.sell_comission, data);
  }

  Future<ResponseApi> excecuteSell(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.sell, data);
  }

  Future<ResponseApi> getBuyCommision(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.buy_comission, data);
  }

  Future<ResponseApi> excecuteBuy(dynamic data) async {
    return _apiProvider.genericPost(ApiEndpoints.buy, data);
  }

  Future<ResponseApi> getPaymentMethods() async {
    return _apiProvider.genericGet(ApiEndpoints.payment_methods);
  }

  Future<dynamic> getTransactions({
    String? startDate,
    String? endDate,
    String? status,
    int? pageSize,
    int? page,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (status != null) queryParams['status'] = status;
    if (pageSize != null) queryParams['page_size'] = pageSize;
    if (page != null) queryParams['page'] = page;

    return _apiProvider.genericGet(
      ApiEndpoints.transaction_history,
      queryParams: queryParams,
    );
  }

  Future<ResponseApi> getTransactionDetail(String id) {
    return _apiProvider.genericGet("${ApiEndpoints.transaction_history}/$id");
  }

  Future<ResponseApi> getTokenPriceHistory({
    required String token,
    required String mode,
  }) {
    return _apiProvider.genericGet(
      "${ApiEndpoints.token_price_history}$token/history/$mode",
    );
  }
}
