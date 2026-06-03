//? PROVIDERS

//? MODELS

import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/request/auth_models.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class AuthRepository {
  final ApiProvider _apiProvider = ApiProvider();

  AuthRepository();

  Future<ResponseApi> getSessionUrl() async {
    return await _apiProvider.genericPost(ApiEndpoints.session_url, null);
  }

  Future<ResponseApi> getSumsubToken() async {
    return await _apiProvider.genericPost(ApiEndpoints.sumsub_access_token, null);
  }

  Future<ResponseApi> authData(AuthUser authUser) async {
    return await _apiProvider.genericPost(
      ApiEndpoints.kyc_data,
      authUser.toJson(),
    );
  }

  Future<ResponseApi> validatePassword(dynamic data) async {
    return await _apiProvider.genericPost(ApiEndpoints.validate_password, data);
  }

  Future<ResponseApi> logout() async {
    return _apiProvider.genericPost(ApiEndpoints.logout, null);
  }
}
