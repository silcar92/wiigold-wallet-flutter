import 'package:get/get.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/core/services/location/repositories/location_repository.dart';
import 'package:wiigold/app/data/models/entities/locations_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';


class LocationController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: 'LocationController');

  final LocationRepository _locationRepository = LocationRepository();

  final RxList<Country> countries = <Country>[].obs;
  final RxList<Region> regions = <Region>[].obs;

  final RxBool _hasCountriesLoaded = false.obs;

  Future<void> initializeCountries() async {
    if (_hasCountriesLoaded.value) return;

    logger.log(label: 'load countries');

    showLoading(context: Get.context!);

    try {
      final ResponseApi res = await _locationRepository.getCountries();

      if (res.code == 200) {
        final List<dynamic> rawDataList = res.data as List<dynamic>;
        final List<Country> loadedCountries =
            rawDataList
                .whereType<Map<String, dynamic>>()
                .map((jsonMap) => Country.fromJson(jsonMap))
                .toList();
        countries.assignAll(loadedCountries);
        _hasCountriesLoaded.value = true;
      } else {
        countries.clear();
      }
    } catch (e) {
      print("LocationController: Error al cargar países: $e");
      countries.clear();
    } finally {
      dismissLoading();
    }
  }

  Future<void> fetchRegionsByCountry(String countryId) async {
    if (countryId.isEmpty) {
      regions.clear();
      return;
    }

    showLoading(context: Get.context!);

    regions.clear();

    try {
      final ResponseApi res = await _locationRepository.getRegionsByCountry(
        int.parse(countryId),
      );

      if (res.code == 200 || res.status == 'success') {
        final List<dynamic> rawDataList = res.data as List<dynamic>;

        final List<Region> loadedRegions =
            rawDataList
                .whereType<Map<String, dynamic>>()
                .map((jsonMap) => Region.fromJson(jsonMap))
                .toList();
        regions.assignAll(loadedRegions);
      } else {
        regions.clear();
      }
    } catch (e) {
      print(
        "LocationController: Error al cargar regiones para el país $countryId: $e",
      );
      regions.clear();
    } finally {
      dismissLoading();
    }
  }
}
