//? MODELS
import 'package:wiigold/app/common/directory/endpoints.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/providers/api_provider.dart';

class LocationRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ResponseApi> getCountries() async {
    return _apiProvider.genericGet(ApiEndpoints.countries);
  }

  Future<ResponseApi> getRegionsByCountry(int country_id) async {
    return _apiProvider.genericGet("${ApiEndpoints.regions}$country_id");
  }
}
