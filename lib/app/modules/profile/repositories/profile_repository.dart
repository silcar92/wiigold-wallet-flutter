//? PROVIDERS

//? MODELS

import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class ProfileRepository {
  final ApiProvider _apiProvider = ApiProvider();

  ProfileRepository();

  Future<ResponseApi> getUserProfile() async {
    return _apiProvider.genericGet(ApiEndpoints.profile);
  }

  Future<ResponseApi> getUpdateProfileData(Map<String, dynamic> data) async {
    return _apiProvider.genericPatch(ApiEndpoints.profile, data);
  }

  Future<ResponseApi> updateEmail(Map<String, dynamic> data) async {
    return _apiProvider.genericPatch(ApiEndpoints.change_email, data);
  }

}
