import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class SecurityRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ResponseApi> setup2FA() async {
    return _apiProvider.genericGet(ApiEndpoints.totp_setup);
  }

  Future<ResponseApi> verifySetup2FA(String totpCode) async {
    return _apiProvider.genericPost(ApiEndpoints.totp_verify_setup, {'totp_code': totpCode});
  }

  Future<ResponseApi> disable2FA(String totpCode) async {
    return _apiProvider.genericPost(ApiEndpoints.totp_disable, {'totp_code': totpCode});
  }

  Future<ResponseApi> verify2FACode(String totpCode) async {
    return _apiProvider.genericPost(ApiEndpoints.totp_verify, {'totp_code': totpCode});
  }
}
