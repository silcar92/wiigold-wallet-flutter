//? GetX
import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';

//? REPOSITORIES

//? MIXINS
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';

//? MODELS
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/config/environment.dart';

class WalletController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "walletController");

  final WalletRepository _walletRepository = WalletRepository();

  final RxString mainAvailableBalance = '0.00'.obs;
  final RxString wiigoldAvailableBalance = '0.00'.obs;

  RxList<AssetBalance> tokens = <AssetBalance>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeBalances() async {
    showLoading();

    await chargeAllBalances();

    dismissLoading();
  }

  Future<void> chargeHauvBalance() async {
    await chargeAllBalances();

    final double totalPortfolioValue = tokens.fold<double>(0.0, (sum, asset) {
      final String normalizedAvailable = (asset.available ?? '0')
          .toHauvNumericString();

      final double availableAmount = normalizedAvailable.toDouble();

      final String normalizedRate =
          (asset.asset_info?.rateChange?.currentRate ?? '0').replaceAll(
            ',',
            '.',
          );

      final double rateInUsd = double.tryParse(normalizedRate) ?? 0.0;

      if (asset.asset_code == EnvironmentConfig.goldToken) {
        wiigoldAvailableBalance.value = "${availableAmount * rateInUsd}";
      }

      return sum + (availableAmount * rateInUsd);
    });

    mainAvailableBalance.value = totalPortfolioValue.toStringAsFixed(2);
  }

  Future<void> chargeAllBalances() async {
    try {
      final ResponseApi res = await _walletRepository.getAllBalance();

      if (res.status == 'error') {
        tokens.clear();
        return;
      }

      if (res.data == null || res.data is! Map<String, dynamic>) {
        tokens.clear();
        return;
      }

      final Map<String, dynamic> responseData =
          res.data as Map<String, dynamic>;

      if (!responseData.containsKey('balances') ||
          responseData['balances'] is! List) {
        tokens.clear();
        return;
      }

      final List<dynamic> balancesJsonList =
          responseData['balances'] as List<dynamic>;

      List<AssetBalance> fetchedBalances = balancesJsonList
          .map((jsonItem) {
            if (jsonItem is Map<String, dynamic>) {
              try {
                logger.log(
                  enable: false,
                  label: "AssetBalance",
                  customData: jsonItem,
                );

                return AssetBalance.fromJson(jsonItem);
              } catch (e) {
                print("Error parsing AssetBalance: $e, item: $jsonItem");
                return null;
              }
            }
            return null;
          })
          .whereType<AssetBalance>()
          .toList();

      final List<String> sortOrder = [
        EnvironmentConfig.goldToken,
        EnvironmentConfig.silverToken,
        EnvironmentConfig.copperToken,
        EnvironmentConfig.ironToken,
        EnvironmentConfig.xautToken,
        EnvironmentConfig.usdtToken,
      ];

      fetchedBalances.sort((a, b) {
        final int indexA = sortOrder.indexOf(a.asset_code ?? '');
        final int indexB = sortOrder.indexOf(b.asset_code ?? '');

        final int priorityA = indexA == -1 ? sortOrder.length : indexA;
        final int priorityB = indexB == -1 ? sortOrder.length : indexB;

        return priorityA.compareTo(priorityB);
      });

      tokens.assignAll(fetchedBalances);
    } catch (e) {
      print("Error en getAllTokens: $e");
      tokens.clear();
    } finally {
      dismissLoading();
    }
  }
}
