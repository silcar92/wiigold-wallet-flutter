//? PROVIDERS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';

class TransactionRepository {
  final ApiProvider _apiProvider = ApiProvider();

  TransactionRepository();

  Future<ResponseApi> getTransactionDetail(String id) async {
    return _apiProvider.genericGet("${ApiEndpoints.transaction_detail}$id");
  }
}
