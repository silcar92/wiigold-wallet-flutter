import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/core/services/wallet/repositories/wallet_repository.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/theme/Colors.dart';

enum ChartModes { day, week, month, quarter, year }

class TokenController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "TokenController");
  final WalletRepository _walletRepository = WalletRepository();

  TextTheme get textTheme => Theme.of(Get.context!).textTheme;

  final Rx<AssetBalance?> t = Rx(null);
  Timer? _priceUpdateTimer;

  final RxString price = ''.obs;
  final RxString tendency = ''.obs;
  final RxString tendencyDirection = ''.obs;
  final RxString lastPriceUpdate = ''.obs;
  final RxString currentChartMode = 'MONTH'.obs;
  final RxList<Map<String, dynamic>> priceChartSource =
      <Map<String, dynamic>>[].obs;

  final List<Map<String, dynamic>> chartModeOptions = [
    {"label": '1 Día', "value": "DAY"},
    {"label": '1 Semana', "value": "WEEK"},
    {"label": '1 Mes', "value": "MONTH"},
    {"label": '3 Meses', "value": "QUARTER"},
    {"label": '1 Año', "value": "YEAR"},
  ];

  @override
  void onInit() {
    super.onInit();
    _handleInitialParams();
  }

  @override
  void onClose() {
    stopPriceTimer();
    super.onClose();
  }

  void _handleInitialParams() {
    final params = Get.parameters;
    if (params['data'] != null) {
      final String jsonDataString = params['data']!;
      final dynamic data = jsonDecode(jsonDataString);
      final asset = data['asset'];
      t.value = AssetBalance.fromJson(asset);
      changeChartMode('MONTH');
    }
  }

  Future<void> chargeData({bool showLoader = true}) async {
    stopPriceTimer();
    if (showLoader) {
      showLoading(context: Get.context!);
    }
    lastPriceUpdate.value = DateFormat(
      'HH:mm:ss',
      'es_ES',
    ).format(DateTime.now());
    try {
      ResponseApi currentAssetBalance = await _walletRepository.getTokenBalance(
        t.value!.asset_code!,
      );
      if (currentAssetBalance.status == 'error') return;
      if (currentAssetBalance.data == null ||
          currentAssetBalance.data is! Map<String, dynamic>)
        return;
      final Map<String, dynamic> responseData =
          currentAssetBalance.data as Map<String, dynamic>;
      if (!responseData.containsKey('balances') ||
          responseData['balances'] is! List)
        return;
      final List<dynamic> balancesJsonList =
          responseData['balances'] as List<dynamic>;
      List<AssetBalance> fetchedBalances = balancesJsonList
          .map((jsonItem) {
            if (jsonItem is Map<String, dynamic>) {
              try {
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
      t.value = fetchedBalances[0];
    } catch (e, s) {
      logger.crashlyticsError(error: e, stackTrace: s, tag: "getTokenBalance");
    }
    await formatTendency();
    try {
      ResponseApi res = await _walletRepository.getTokenPriceHistory(
        mode: currentChartMode.value,
        token: t.value?.asset_code ?? '',
      );
      if (res.data != null && res.data is List) {
        final List<Map<String, dynamic>> rawData =
            List<Map<String, dynamic>>.from(res.data);
        priceChartSource.value = _getProcessedChartData(
          rawData,
          currentChartMode.value,
        );
      } else {
        priceChartSource.clear();
      }
    } catch (e, s) {
      priceChartSource.clear();
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'getTokenPriceHistory',
      );
    } finally {
      if (showLoader) {
        dismissLoading();
      }
    }
    startPriceTimer();
  }

  List<Map<String, dynamic>> _getProcessedChartData(
    List<Map<String, dynamic>> rawData,
    String mode,
  ) {
    if (rawData.isEmpty) return [];
    List<Map<String, dynamic>> sortedData = rawData.map((e) {
      return {...e, 'parsed_date': DateTime.parse(e['effective_date'])};
    }).toList();
    sortedData.sort((a, b) => a['parsed_date'].compareTo(b['parsed_date']));
    final now = DateTime.now();
    List<Map<String, dynamic>> result = [];
    switch (mode) {
      case 'DAY':
        final startTime = now.subtract(const Duration(hours: 24));
        final hourlyData = groupBy(
          sortedData.where((d) => d['parsed_date'].isAfter(startTime)),
          (d) => DateFormat('yyyy-MM-dd HH', 'es_ES').format(d['parsed_date']),
        );
        result = hourlyData.values.map((group) => group.last).toList();
        break;
      case 'WEEK':
        final startTime = now.subtract(const Duration(days: 7));
        final dailyData = groupBy(
          sortedData.where((d) => d['parsed_date'].isAfter(startTime)),
          (d) => DateFormat('yyyy-MM-dd', 'es_ES').format(d['parsed_date']),
        );
        result = dailyData.values.map((group) => group.last).toList();
        break;
      case 'MONTH':
        final startTime = now.subtract(const Duration(days: 30));
        final dailyDataMonth = groupBy(
          sortedData.where((d) => d['parsed_date'].isAfter(startTime)),
          (d) => DateFormat('yyyy-MM-dd', 'es_ES').format(d['parsed_date']),
        );
        result = dailyDataMonth.values.map((group) => group.last).toList();
        break;
      case 'QUARTER':
        final startTime = now.subtract(const Duration(days: 90));
        final weeklyData = groupBy(
          sortedData.where((d) => d['parsed_date'].isAfter(startTime)),
          (d) {
            final date = d['parsed_date'] as DateTime;
            final startOfYear = DateTime(date.year, 1, 1);
            final firstMonday = startOfYear.weekday > 1
                ? startOfYear.add(Duration(days: 8 - startOfYear.weekday))
                : startOfYear;
            final weekNumber =
                1 + (date.difference(firstMonday).inDays / 7).floor();
            return '${date.year}-$weekNumber';
          },
        );
        result = weeklyData.values.map((group) => group.last).toList();
        break;
      case 'YEAR':
        final startTime = now.subtract(const Duration(days: 365));
        final monthlyData = groupBy(
          sortedData.where((d) => d['parsed_date'].isAfter(startTime)),
          (d) => DateFormat('yyyy-MM', 'es_ES').format(d['parsed_date']),
        );
        result = monthlyData.values.map((group) => group.last).toList();
        break;
      default:
        result = sortedData;
    }
    result.sort((a, b) => a['parsed_date'].compareTo(b['parsed_date']));
    return result;
  }

  Future<void> updatePrice() async {
    await chargeData(showLoader: false);
  }

  void startPriceTimer() {
    stopPriceTimer();
    _priceUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updatePrice();
    });
  }

  void stopPriceTimer() {
    _priceUpdateTimer?.cancel();
  }

  Future<void> formatTendency() async {
    final rateChange = t.value?.asset_info?.rateChange;
    price.value =
        rateChange?.currentRate.toString().toHauvNumericString(decimals: 2) ??
        "0.00";
    final double variation = rateChange?.variation ?? 0.0;
    final String sign = rateChange?.changeType == 'increased'
        ? '+'
        : rateChange?.changeType == 'decreased'
        ? '-'
        : '';
    tendency.value = '$sign${variation.abs().toStringAsFixed(2)}%';
    switch (rateChange?.changeType) {
      case 'increased':
        tendencyDirection.value = 'INCREMENT';
        break;
      case 'decreased':
        tendencyDirection.value = 'DECREMENT';
        break;
      default:
        tendencyDirection.value = '';
        break;
    }
  }

  LineChartData getMainChart() {
    List<FlSpot> spots = priceChartSource.asMap().entries.map((entry) {
      int index = entry.key;
      double rate = "${entry.value['rate_usd']}".toDouble();
      return FlSpot(index.toDouble(), rate);
    }).toList();

    if (spots.isEmpty) {
      return LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
      );
    }

    double minDataX = 0;
    double maxDataX = (priceChartSource.length - 1).toDouble();

    if (spots.length == 1) {
      final singleSpot = spots.first;
      spots = [FlSpot(0.0, singleSpot.y), FlSpot(1.0, singleSpot.y)];
      maxDataX = 1.0;
    }

    double minYValue = spots
        .map((spot) => spot.y)
        .reduce((a, b) => a < b ? a : b);
    double maxYValue = spots
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);

    if (minYValue == maxYValue) {
      minYValue = minYValue * 0.95;
      maxYValue = maxYValue * 1.05;
      if (minYValue == 0 && maxYValue == 0) {
        minYValue = -1;
        maxYValue = 1;
      }
    } else {
      double padding = (maxYValue - minYValue) * 0.05;
      minYValue -= padding;
      maxYValue += padding;
    }

    final lineChartBarData = LineChartBarData(
      color: AppColors.main,
      spots: spots,
      isCurved: true,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );

    Widget bottomTitleWidgets(double value, TitleMeta meta) {
      final style = textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
      );
      String text = '';

      if (priceChartSource.isEmpty) return Container();

      if (value.toInt() == 0 || value.toInt() == maxDataX.toInt()) {
        try {
          int index = (priceChartSource.length == 1)
              ? 0
              : (value.toInt() == 0 ? 0 : priceChartSource.length - 1);
          final dateString = priceChartSource[index]['effective_date'];
          final date = DateTime.parse(dateString);
          text = DateFormat('MMM d', 'es_ES').format(date);
        } catch (e) {
          text = '';
        }
      }

      return SideTitleWidget(
        space: 8.0,
        meta: meta,
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 20),
          child: Text(text, style: style),
        ),
      );
    }

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(bottom: BorderSide(width: 1, color: AppColors.dark2)),
      ),
      minX: minDataX,
      maxX: maxDataX,
      minY: minYValue,
      maxY: maxYValue,
      lineBarsData: [lineChartBarData],
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => AppColors.dark2,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots
                .map((spot) {
                  final int sourceIndex;
                  if (priceChartSource.length == 1) {
                    sourceIndex = 0;
                  } else {
                    sourceIndex = spot.x.toInt();
                  }

                  if (sourceIndex < 0 || sourceIndex >= priceChartSource.length)
                    return null;

                  final Map<String, dynamic> dataPoint =
                      priceChartSource[sourceIndex];
                  final date = DateTime.parse(dataPoint['effective_date']);
                  String dateText;
                  switch (currentChartMode.value) {
                    case 'DAY':
                      dateText = DateFormat(
                        'MMM d, HH:mm',
                        'es_ES',
                      ).format(date);
                      break;
                    case 'WEEK':
                    case 'MONTH':
                      dateText = DateFormat('EEEE d', 'es_ES').format(date);
                      break;
                    default:
                      dateText = DateFormat(
                        'MMM d, yyyy',
                        'es_ES',
                      ).format(date);
                  }
                  final String priceText = spot.y.toHauvNumericString(
                    decimals: 2,
                  );
                  return LineTooltipItem(
                    '$priceText USD\n',
                    TextStyle(
                      color: AppColors.dark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: dateText,
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                    textAlign: TextAlign.left,
                  );
                })
                .whereNotNull()
                .toList();
          },
        ),
      ),
    );
  }

  void changeChartMode(String mode) {
    currentChartMode.value = mode;
    chargeData();
  }
}
