import 'dart:convert';

enum CardStatus { ACTIVE, INACTIVE, BLOCKED, UNKNOWN }

enum CardType { VIRTUAL, PHYSICAL, UNKNOWN }

class CardModel {
  final CardStatus status;
  final CardType cardType;
  final bool isFrozen;
  final String partnerToken;
  final DateTime? physicalCardRequestedAt;
  final String? cardNumber;
  final String? cvv;
  final String? expiryDate;

  CardModel({
    required this.status,
    required this.cardType,
    required this.isFrozen,
    required this.partnerToken,
    this.physicalCardRequestedAt,
    this.cardNumber,
    this.cvv,
    this.expiryDate,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      status: _parseStatus(json['status']),
      cardType: _parseCardType(json['card_type']),
      isFrozen: json['is_frozen'] ?? false,
      partnerToken: json['partner_token'] ?? '',
      physicalCardRequestedAt: json['physical_card_requested_at'] != null
          ? DateTime.parse(json['physical_card_requested_at'])
          : null,
      cardNumber: json['card_number'],
      cvv: json['cvv'],
      expiryDate: json['expiry_date'],
    );
  }

  CardModel copyWith({
    CardStatus? status,
    CardType? cardType,
    bool? isFrozen,
    String? partnerToken,
    DateTime? physicalCardRequestedAt,
    String? cardNumber,
    String? cvv,
    String? expiryDate,
  }) {
    return CardModel(
      status: status ?? this.status,
      cardType: cardType ?? this.cardType,
      isFrozen: isFrozen ?? this.isFrozen,
      partnerToken: partnerToken ?? this.partnerToken,
      physicalCardRequestedAt:
          physicalCardRequestedAt ?? this.physicalCardRequestedAt,
      cardNumber: cardNumber ?? this.cardNumber,
      cvv: cvv ?? this.cvv,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  static CardStatus _parseStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACTIVE':
        return CardStatus.ACTIVE;
      case 'INACTIVE':
        return CardStatus.INACTIVE;
      case 'BLOCKED':
        return CardStatus.BLOCKED;
      default:
        return CardStatus.UNKNOWN;
    }
  }

  static CardType _parseCardType(String? type) {
    switch (type?.toUpperCase()) {
      case 'VIRTUAL':
        return CardType.VIRTUAL;
      case 'PHYSICAL':
        return CardType.PHYSICAL;
      default:
        return CardType.UNKNOWN;
    }
  }
}

class MerchantInfo {
  final String merchantId;
  final String merchantCategoryCode;

  MerchantInfo({required this.merchantId, required this.merchantCategoryCode});

  factory MerchantInfo.fromJson(Map<String, dynamic> json) {
    return MerchantInfo(
      merchantId: json['merchant_id'] ?? 'N/A',
      merchantCategoryCode: json['merchant_category_code'] ?? 'N/A',
    );
  }
}

class CardTransaction {
  final String transactionId;
  final String amount;
  final String currency;
  final String transactionType;
  final String status;
  final String processingStatus;
  final MerchantInfo merchantInfo;
  final DateTime createdAt;

  CardTransaction({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.transactionType,
    required this.status,
    required this.processingStatus,
    required this.merchantInfo,
    required this.createdAt,
  });

  factory CardTransaction.fromJson(Map<String, dynamic> json) {
    return CardTransaction(
      transactionId: json['transaction_id'],
      amount: json['amount'],
      currency: json['currency'],
      transactionType: json['transaction_type'] ?? json['operationType'],
      status: json['status'],
      processingStatus: json['processing_status'],
      merchantInfo: MerchantInfo.fromJson(json['merchant_info'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
