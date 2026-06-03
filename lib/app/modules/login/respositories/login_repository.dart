import 'dart:convert';

//? PROVIDERS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/directory/success.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/request/login_model.dart';

//? STORAGE
import 'package:wiigold/app/data/storage/token_storage.dart';

//?

class LoginRepository {
  final TokenStorage _tokenStorage = TokenStorage();
  final ApiProvider _apiProvider = ApiProvider();

  LoginRepository();

  Future<ResponseApi> avilableEmail(String email) async {
    return await _apiProvider.genericPost(ApiEndpoints.avilable_email, {
      "email": email,
    });
  }

  Future<ResponseApi> login(Login loginData) async {
    try {
      final response = await _apiProvider.executePost(
        endpoint: ApiEndpoints.login,
        data: loginData.toJson(),
      );

      if (response.statusCode == 404) {
        return ResponseApi(
          status: "error",
          code: 404,
          message: AppErrors.getErrorLabel("CONNECTION_ERROR"),
          message_code: "CONNECTION_ERROR",
          error: 'error',
          data: null,
        );
      }

      final jsonResponse = jsonDecode(response.body);

      final ResponseApi responseApi = ResponseApi(
        code: response.statusCode,
        message_code: jsonResponse['message'],
        error: jsonResponse['error'] ?? 'error',
        data: jsonResponse['data'] ?? 'data',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return responseApi.copyWith(
          status: "error",
          message: AppErrors.getErrorLabel(jsonResponse['message']),
        );
      }

      if (responseApi.message_code == 'LOGIN_SUCCESS') {
        final accessToken =
            (responseApi.data as Map<String, dynamic>)['id_token']?.toString();

        if (accessToken != null) _tokenStorage.setCurrentToken(accessToken);
      }

      return responseApi.copyWith(
        status: "success",
        message: AppSuccess.getSuccessLabel(jsonResponse['message']),
      );
    } catch (err) {
      return ResponseApi(
        status: "error",
        code: 500,
        message: "Error en el proceso de login",
        error: err.toString(),
        data: null,
      );
    }
  }
}
