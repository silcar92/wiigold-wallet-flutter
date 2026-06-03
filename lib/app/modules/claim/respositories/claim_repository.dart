import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class ClaimRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ResponseApi> getClaimCategoriesWithDetails() async {
    return _apiProvider.genericGet(ApiEndpoints.claimCategories);
  }

  Future<ResponseApi> createClaim(Map<String, dynamic> data) async {
    return _apiProvider.genericPost(ApiEndpoints.createClaim, data);
  }
}
