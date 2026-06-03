//? PROVIDERS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';

class RecoveryRepository {
  final ApiProvider _apiProvider = ApiProvider();

  RecoveryRepository();

  Future<ResponseApi> requestOtp({required String email}) async {
    return await _apiProvider.genericPost(ApiEndpoints.request_otp, {
      "email": email,
    });
  }

  Future<ResponseApi> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await _apiProvider.genericPost(ApiEndpoints.verify_otp, {
      "email": email,
      "otp_code": otp,
    });
  }

  Future<ResponseApi> changePassword({
    required String email,
    required String newpassword,
    required String otp,
  }) async {
    return await _apiProvider.genericPost(ApiEndpoints.change_password, {
      "email": email,
      "new_password": newpassword,
      "otp_code": otp,
    });
  }
}
