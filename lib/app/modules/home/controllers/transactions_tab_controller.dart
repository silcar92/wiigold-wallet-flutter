import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/mixins/transactions_cluster_mixin.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';

import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';

class TransactionsTabController extends GetxController
    with
        GetSingleTickerProviderStateMixin,
        LoadingMixin,
        TransactionsClusterMixin {
  late TextTheme textTheme;

  final WalletRepository walletRepository = WalletRepository();
  final WalletController walletController = Get.find<WalletController>();

  late final TabController tabController = TabController(
    vsync: this,
    length: tabs.length,
  );

  final tabs = <Tab>[
    Tab(text: 'home.transactions_tab_controller.tab_tokens'.tr),
    Tab(text: 'home.transactions_tab_controller.tab_transactions'.tr),
  ];

  final RxList transactions = [].obs;
  RxList<AssetBalance> tokens = <AssetBalance>[].obs;

  static const int _initialPageKey = 1;
  static const int _pageSize = 10;

  @override
  void onReady() {
    super.onReady();
    textTheme = Theme.of(Get.context!).textTheme;
  }

  Future<void> refreshData() async {
    showLoading();

    try {
      await Future.wait([
        _fetchAndSetTransactions(_initialPageKey),
        _fetchAndSetAllBalances(),
      ]);
    } catch (e) {
      print("Error durante refreshData: $e");
    } finally {
      dismissLoading();
    }
  }

  Future<void> _fetchAndSetTransactions(int pageKey) async {
    try {
      final List<Map<String, dynamic>> fetchedTransactions =
          await getTransactions(pageKey);

      transactions.assignAll(fetchedTransactions);
    } catch (e) {
      print("Error en _fetchAndSetTransactions: $e");
      transactions.clear();
    }
  }

  Future<void> _fetchAndSetAllBalances() async {
    tokens.assignAll(walletController.tokens);
  }

  Future<List<Map<String, dynamic>>> getTransactions(int pageKey) async {
    try {
      final ResponseApi res = await walletRepository.getTransactions(
        pageSize: _pageSize,
        page: pageKey,
      );

      if (res.status == 'error' || res.data == null) {
        print("error: ${res.error}");

        return [];
      }

      final data = res.data as Map<String, dynamic>;

      if (data['results'] is! List) {
        return [];
      }
      final List<dynamic> results = data['results'] as List<dynamic>;

      return results.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}
