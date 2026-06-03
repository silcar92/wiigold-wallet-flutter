//? PROVIDERS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/request/register_model.dart';

class RegisterRepository {
  final ApiProvider apiProvider = ApiProvider();

  RegisterRepository();

  Future<ResponseApi> register(Register register) async {
    return await apiProvider.genericPost(
      ApiEndpoints.register,
      register.toJson(),
    );
  }
}
