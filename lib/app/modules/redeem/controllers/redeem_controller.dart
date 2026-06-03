import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/mixins/loading_mixin.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/core/services/wallet/controllers/wallet_controller.dart';
import 'package:wiigold/app/data/models/entities/redeems_model.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/models/responses/balance_model.dart';
import 'package:wiigold/app/modules/redeem/repositories/redeem_repository.dart';
import 'package:wiigold/app/routers/app_routes.dart';

class RedeemController extends GetxController with LoadingMixin {
  final Logger logger = Logger(module: "RedeemController");
  final RedeemRepository _redeemRepository = RedeemRepository();
  final WalletController walletController = Get.find<WalletController>();

  late final TextTheme textTheme;

  final RxList<AssetBalance> tokens = <AssetBalance>[].obs;
  final Rx<AssetBalance?> selectedToken = Rx<AssetBalance?>(null);

  final RxList<Redeem> redeems = <Redeem>[].obs;

  @override
  void onInit() {
    super.onInit();
    textTheme = Theme.of(Get.context!).textTheme;
    chargeData();
  }

  Future<void> chargeData() async {
    showLoading(context: Get.context!);
    try {
      await Future.wait([getRedeemList(), getAllTokens()]);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'chargeDataFailure',
        reason: 'Error al cargar los datos iniciales de Redeem.',
      );
      DynamicToast.error(title: 'redeem.controller.load_data_error'.tr);
    } finally {
      dismissLoading(context: Get.context!);
    }
  }

  Future<void> getAllTokens() async {
    try {
      await walletController.chargeAllBalances();

      final withdrawableTokens = walletController.tokens.where(
        (token) => token.asset_info?.is_withdrawable ?? false,
      );

      tokens.assignAll(withdrawableTokens);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'getAllTokensFailure',
        reason: 'Falló la obtención o filtrado de tokens retirables.',
      );
      rethrow;
    }
  }

  Future<void> getRedeemList() async {
    try {
      final ResponseApi res = await _redeemRepository.redeemList();

      if (res.status == 'error') {
        await logger.crashlyticsReport(
          tag: 'getRedeemListApiError',
          reportMessage: res.message,
          customData: {
            'api_response': res.toString(),
            'api_message_code': res.message_code,
            'http_status_code': res.code,
          },
        );
        DynamicToast.error(title: AppErrors.getErrorLabel(res.message));

        redeems.clear();
        return;
      }

      switch (res.message_code) {
        case 'MINERAL_WITHDRAWAL_REQUEST_LIST_SUCCESS':
          if (res.data is List) {
            final List<Redeem> redeemList = (res.data as List)
                .map((item) => Redeem.fromJson(item as Map<String, dynamic>))
                .toList();

            redeems.assignAll(redeemList);
          } else {
            logger.crashlyticsReport(
              tag: 'RedeemDataFormatError',
              reportMessage:
                  'API devolvió SUCCESS pero res.data no es una lista.',
              customData: {
                'expected_type': 'List',
                'received_type': res.data?.runtimeType.toString() ?? 'null',
                'api_response': res.toString(),
              },
            );
            redeems.clear();
          }
          break;

        case 'MINERAL_WITHDRAWAL_REQUEST_LIST_EMPTY':
          redeems.clear();
          logger.log(
            label: "Redeems Empty",
            content:
                "La consulta fue exitosa pero la lista de redeems está vacía.",
          );
          break;

        default:
          logger.crashlyticsReport(
            tag: 'UnknownMessageCode',
            reportMessage: 'La API devolvió un message_code desconocido.',
            customData: {
              'message_code': res.message_code,
              'api_response': res.toString(),
            },
          );

          DynamicToast.error(title: 'redeem.controller.unexpected_response'.tr);
          redeems.clear();
          break;
      }
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'getRedeemListFailure',
      );

      redeems.clear();

      rethrow;
    }
  }

  void updateSelectedToken(AssetBalance token) {
    selectedToken.value = token;

    final availableAmount = selectedToken.value?.available?.toDouble() ?? 0.0;

    if (availableAmount <= 0) {
      DynamicToast.error(
        title: 'redeem.controller.amount_not_available_title'.tr,
        description: 'redeem.controller.amount_not_available_description'.tr,
      );
      return;
    }

    Get.toNamed(
      AppRoutes.REDEEM_REQUEST,
      parameters: {
        "data": jsonEncode({"asset": selectedToken.value!.toJson()}),
      },
    );
  }
}
