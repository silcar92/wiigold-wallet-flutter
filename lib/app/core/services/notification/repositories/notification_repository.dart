//? PROVIDERS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';

class NotificationRepository {
  final ApiProvider _apiProvider = ApiProvider();

  NotificationRepository();

  Future<ResponseApi> getAllNotifications() async {
    return _apiProvider.genericGet(ApiEndpoints.get_notifications);
  }

  Future<ResponseApi> updateFCM(Map<String, dynamic> data) async {
    return _apiProvider.genericPatch(ApiEndpoints.change_fcm_token, data);
  }
}
