import 'package:get/get.dart';
import 'package:wiigold/app/data/models/entities/card_model.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/app/data/models/entities/transactions_model.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:intl/intl.dart';

mixin TransactionsClusterMixin {
  final Logger logger = Logger(module: "TransactionsClusterMixin");

  void redirectToTransaction(Map<String, dynamic> rawDataPayload) {
    logger.log(label: 'redirectToTransaction', customData: rawDataPayload);

    final apiResponse = rawDataPayload['apiResponse'] as Map<String, dynamic>?;

    if (apiResponse == null) {
      return;
    }

    final operationType =
        apiResponse['operationType'] as String? ??
        apiResponse['transaction_from']?['operationType'] as String?;
    final perspective = rawDataPayload['perspective'] as String?;

    bool success = false;

    switch (operationType) {
      case 'transfer':
        if (perspective == 'SENDER') {
          success = fromSend(rawDataPayload: rawDataPayload);
        } else if (perspective == 'RECEIVER') {
          success = fromReceiving(rawDataPayload: rawDataPayload);
        }
        break;

      case 'exchange':
        success = fromExchange(rawDataPayload: rawDataPayload);
        break;

      case 'offramp':
        success = fromSell(rawDataPayload: rawDataPayload);
        break;

      case 'onramp':
        success = fromBuy(rawDataPayload: rawDataPayload);
        break;
      case 'CARD_PURCHASE':
        success = fromCardTransaction(rawDataPayload: rawDataPayload);
        break;
      default:
        print(
          'TransactionsClusterMixin: Tipo de operación desconocido "$operationType"',
        );
        success = false;
    }
  }

  bool fromCardTransaction({required Map<String, dynamic> rawDataPayload}) {
    try {
      final cardTransactionData =
          rawDataPayload['apiResponse'] as Map<String, dynamic>;
      final cardTransaction = CardTransaction.fromJson(cardTransactionData);

      final transactionForDetail = {
        "transaction_id": cardTransaction.transactionId,
        "amount": double.tryParse(cardTransaction.amount) ?? 0.0,
        "date": DateFormat('dd-MM-yyyy').format(cardTransaction.createdAt),
        "time": DateFormat('HH:mm:ss').format(cardTransaction.createdAt),
        "status": cardTransaction.status,
        "operationType": "CARD_PURCHASE",
        "details": {
          "currency": {"name": cardTransaction.currency},
        },
      };

      final transaction = Transaction.fromJson(transactionForDetail);

      final Map<String, dynamic> navigationData = {
        "merchantName": cardTransaction.merchantInfo.merchantId,
        "merchantCategory": cardTransaction.merchantInfo.merchantCategoryCode,
      };

      final parameters = transaction.toGetNamedParameters(
        viewMode: 'CARD_PURCHASE',
        appbarTitle: "Detalle de Compra",
        data: navigationData,
      );

      Get.toNamed(AppRoutes.TRANSACTION_DETAIL, parameters: parameters);
      return true;
    } catch (e) {
      print('Error dentro de fromCardTransaction: $e');
      return false;
    }
  }

  bool fromSend({required Map<String, dynamic> rawDataPayload}) {
    try {
      final apiResponse = rawDataPayload['apiResponse'] as Map<String, dynamic>;
      final contextualData =
          rawDataPayload['contextualData'] as Map<String, dynamic>? ?? {};
      final transaction = Transaction.fromJson(apiResponse);
      if (transaction.details == null) {
        print("Error en fromSend: Transaction details son nulos.");
        return false;
      }
      final targetData =
          apiResponse['details']?['target'] as Map<String, dynamic>?;
      final String targetName = (targetData != null)
          ? "${targetData['first_name']} ${targetData['last_name'] ?? ''}"
                .trim()
          : "Destinatario";
      final String targetAccount =
          contextualData['targetAccount'] ?? targetData?['email'] ?? 'N/A';
      final Map<String, dynamic> navigationData = {
        "targetName": targetName,
        "targetAccount": targetAccount,
      };
      final fee = transaction.fee.toHauvNumericString();
      final currencySymbol = transaction.details['currency']['name'] ?? '';
      final parameters = transaction.toGetNamedParameters(
        viewMode: 'SEND',
        appbarTitle: "Enviar",
        data: navigationData,
        customExtra: {
          "type": "commission",
          "commission": "$fee $currencySymbol".trim(),
        },
      );
      Get.toNamed(AppRoutes.TRANSACTION_DETAIL, parameters: parameters);
      return true;
    } catch (e) {
      print('Error dentro de fromSend: $e');
      return false;
    }
  }

  bool fromReceiving({required Map<String, dynamic> rawDataPayload}) {
    try {
      final apiResponse = rawDataPayload['apiResponse'] as Map<String, dynamic>;

      final contextualData =
          rawDataPayload['contextualData'] as Map<String, dynamic>? ?? {};
      final transaction = Transaction.fromJson(apiResponse);

      logger.log(label: "transaction.details", customData: transaction.details);

      if (transaction.details == null) {
        print("Error en fromSend: Transaction details son nulos.");

        return false;
      }

      final targetData =
          apiResponse['details']?['target'] as Map<String, dynamic>?;

      final String targetName = (targetData != null)
          ? "${targetData['first_name']} ${targetData['last_name'] ?? ''}"
                .trim()
          : "Destinatario";

      final String targetAccount =
          contextualData['targetAccount'] ?? targetData?['email'] ?? 'N/A';

      final Map<String, dynamic> navigationData = {
        "targetName": targetName,
        "targetAccount": targetAccount,
      };

      final fee = transaction.details['fee']
          .toString()
          .toDouble()
          .toHauvNumericString();
      final currencySymbol = transaction.details['currency']['name'] ?? '';
      final parameters = transaction.toGetNamedParameters(
        viewMode: 'RECEIVER',
        appbarTitle: "Enviar",
        data: navigationData,
        customExtra: {
          "type": "commission",
          "commission": "$fee $currencySymbol".trim(),
        },
      );

      Get.toNamed(AppRoutes.TRANSACTION_DETAIL, parameters: parameters);
      return true;
    } catch (e) {
      print('Error dentro de fromReceiving: $e');

      return false;
    }
  }

  bool fromExchange({required Map<String, dynamic> rawDataPayload}) {
    try {
      final responseData =
          rawDataPayload['apiResponse'] as Map<String, dynamic>;

      final transaction = Transaction.fromJson(responseData);
      final feeAmount = responseData['details']['fee_amount']
          .toString()
          .toDouble();
      final amountFrom = responseData['details']['amount_from']
          .toString()
          .toDouble();
      final assetFromName =
          responseData['details']['asset_from']?['name'] ?? 'N/A';
      final amountTo = responseData['details']['amount_to']
          .toString()
          .toDouble();

      final assetToName = responseData['details']['asset_to']?['name'] ?? 'N/A';

      final parameters = transaction.toGetNamedParameters(
        viewMode: 'EXCHANGE',
        appbarTitle: "Cambiar",
        customExtra: {
          "type": "commission",
          "commission": "${feeAmount.toHauvNumericString()} $assetFromName",
        },
        transactionExtra: {
          "type": "exchange",
          "fromAmout": "${amountFrom.toHauvNumericString()} $assetFromName",
          "toAmout": "${amountTo.toHauvNumericString()} $assetToName",
        },
      );

      Get.toNamed(AppRoutes.TRANSACTION_DETAIL, parameters: parameters);
      return true;
    } catch (e) {
      print('Error dentro de fromExchange: $e');
      return false;
    }
  }

  bool fromBuy({required Map<String, dynamic> rawDataPayload}) {
    try {
      final responseData =
          rawDataPayload['apiResponse'] as Map<String, dynamic>;
      final transaction = Transaction.fromJson(responseData);
      final feeAmount = (responseData['details']?['fee_amount_usd'] ?? 0.0);

      final amountFrom =
          (responseData['details']?['amount_usd'] as double? ?? 0.0);

      final assetFromName = "USD";
      final amountTo = (responseData['amount'] as double? ?? 0.0);
      final assetToName =
          responseData['details']?['currency']?['name'] ?? 'N/A';

      final parameters = transaction.toGetNamedParameters(
        viewMode: 'BUY',
        appbarTitle: "Comprar",
        customExtra: {
          "type": "commission",
          "commission":
              "${(feeAmount as double).toHauvNumericString(decimals: 2)} USD",
        },
        transactionExtra: {
          "type": "transfer",
          "fromAmout":
              "${amountFrom.toHauvNumericString(decimals: 2)} $assetFromName",
          "toAmout": "${amountTo.toHauvNumericString()} $assetToName",
        },
      );

      Get.toNamed(AppRoutes.TRANSACTION_DETAIL, parameters: parameters);

      return true;
    } catch (e, s) {
      print('Error dentro de fromBuy: $e');

      logger.crashlyticsError(error: e, stackTrace: s, tag: "fromBuy error");

      return false;
    }
  }

  bool fromSell({required Map<String, dynamic> rawDataPayload}) {
    try {
      final responseData =
          rawDataPayload['apiResponse'] as Map<String, dynamic>;
      final transaction = Transaction.fromJson(responseData);
      final feeAmount = (responseData['details']?['fee_amount_tokens'] ?? 0.0);
      final amountFrom = (responseData['amount'] as double? ?? 0.0);
      final assetFromName =
          responseData['details']?['currency']?['name'] ?? 'N/A';
      final amountTo =
          (responseData['details']?['amount_usd'] as double? ?? 0.0);
      final assetToName = "USD";
      final parameters = transaction.toGetNamedParameters(
        viewMode: 'SELL',
        appbarTitle: "Vender",
        customExtra: {
          "type": "commission",
          "commission":
              "${(feeAmount as double).toHauvNumericString()} ${responseData['details']?['currency']?['name']}",
        },
        transactionExtra: {
          "type": "transfer",
          "fromAmout": "${amountFrom.toHauvNumericString()} $assetFromName",
          "toAmout": "${amountTo.toHauvNumericString()} $assetToName",
        },
      );
      Get.toNamed(AppRoutes.TRANSACTION_DETAIL, parameters: parameters);
      return true;
    } catch (e) {
      print('Error dentro de fromSell: $e');
      return false;
    }
  }
}
