import 'dart:convert';

import 'package:wiigold/app/common/utils/extensions.dart';
import 'package:wiigold/app/data/models/entities/locations_model.dart';

enum RedeemStatus {
  pendingQuote,
  quoted,
  accepted,
  paymentPending,
  paymentVerified,
  processing,
  processingComplete,
  shipped,
  delivered,
  completed,
  cancelled,
  rejected,
  unknown,
}

extension RedeemStatusExtension on RedeemStatus {
  String get value {
    switch (this) {
      case RedeemStatus.pendingQuote:
        return 'pending_quote';
      case RedeemStatus.quoted:
        return 'quoted';
      case RedeemStatus.accepted:
        return 'accepted';
      case RedeemStatus.paymentPending:
        return 'payment_pending';
      case RedeemStatus.paymentVerified:
        return 'payment_verified';
      case RedeemStatus.processing:
        return 'processing';
      case RedeemStatus.processingComplete:
        return 'processing_complete';
      case RedeemStatus.shipped:
        return 'shipped';
      case RedeemStatus.delivered:
        return 'delivered';
      case RedeemStatus.completed:
        return 'completed';
      case RedeemStatus.cancelled:
        return 'cancelled';
      case RedeemStatus.rejected:
        return 'rejected';
      default:
        return 'unknown';
    }
  }

  String get label {
    switch (this) {
      case RedeemStatus.pendingQuote:
        return 'Pending Quote';
      case RedeemStatus.quoted:
        return 'Quoted';
      case RedeemStatus.accepted:
        return 'Accepted';
      case RedeemStatus.paymentPending:
        return 'Payment received';
      case RedeemStatus.paymentVerified:
        return 'Payment Verified';
      case RedeemStatus.processing:
        return 'Processing';
      case RedeemStatus.shipped:
        return 'Shipped';
      case RedeemStatus.delivered:
        return 'Delivered';
      case RedeemStatus.completed:
        return 'Completed';
      case RedeemStatus.cancelled:
        return 'Cancelled';
      case RedeemStatus.rejected:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  static RedeemStatus fromValue(String? value) {
    return RedeemStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RedeemStatus.unknown,
    );
  }
}

class Asset {
  final String name;
  final String symbol;
  final String code;
  final String assetImageUrl;
  final RateChange rateChange;

  Asset({
    required this.name,
    required this.symbol,
    required this.code,
    required this.assetImageUrl,
    required this.rateChange,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      code: json['code'] as String? ?? '',
      assetImageUrl: json['asset_image_url'] as String? ?? '',
      rateChange: RateChange.fromJson(
        json['rate_change'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'code': code,
      'asset_image_url': assetImageUrl,
      'rate_change': rateChange.toJson(),
    };
  }
}

class RateChange {
  final double variation;
  final dynamic changeType;
  final double oldRate;
  final double currentRate;

  RateChange({
    required this.variation,
    required this.changeType,
    required this.oldRate,
    required this.currentRate,
  });

  factory RateChange.fromJson(Map<String, dynamic> json) {
    return RateChange(
      variation: (json['variation']?.toString() ?? '0.0').toDouble() ?? 0.0,
      changeType: json['change_type']?.toString() ?? '',
      oldRate: (json['old_rate']?.toString() ?? '0.0').toDouble() ?? 0.0,
      currentRate:
          (json['current_rate']?.toString() ?? '0.0').toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variation': variation,
      'change_type': changeType,
      'old_rate': oldRate,
      'current_rate': currentRate,
    };
  }
}

class QuoteCurrency {
  final String name;
  final String code;

  QuoteCurrency({required this.name, required this.code});

  factory QuoteCurrency.fromJson(Map<String, dynamic> json) {
    return QuoteCurrency(
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code};
  }
}

class Redeem {
  final String reference;
  final Asset asset;
  final double quantityRequested;
  final double fee;
  final Country country;
  final Region region;
  final String shippingAddress;
  final String fullname;
  final String zipCode;
  final String phone;
  final RedeemStatus status;
  final String createdAt;
  final String updatedAt;
  final double? quoteAmount;
  final QuoteCurrency? quoteCurrency;
  final String? quoteNotes;
  final double? shippingCost;
  final String? withdrawal_reference;
  final int? estimatedDeliveryDays;
  final String? paymentProof;
  final bool paymentVerified;
  final String? paymentNotes;
  final String? trackingNumber;
  final String? carrierCompany;
  final String? adminNotes;
  final String? quoteDate;
  final String? acceptedDate;
  final String? shippedDate;
  final String? completedDate;

  Redeem({
    required this.reference,
    required this.asset,
    required this.quantityRequested,
    required this.fee,
    required this.country,
    required this.region,
    required this.shippingAddress,
    required this.fullname,
    required this.zipCode,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.quoteAmount,
    this.quoteCurrency,
    this.quoteNotes,
    this.shippingCost,
    this.estimatedDeliveryDays,
    this.withdrawal_reference,
    this.paymentProof,
    required this.paymentVerified,
    this.paymentNotes,
    this.trackingNumber,
    this.carrierCompany,
    this.adminNotes,
    this.quoteDate,
    this.acceptedDate,
    this.shippedDate,
    this.completedDate,
  });

  factory Redeem.fromJson(Map<String, dynamic> json) {
    return Redeem(
      reference: json['reference'] as String? ?? '',
      asset: Asset.fromJson(json['asset'] as Map<String, dynamic>? ?? {}),
      quantityRequested:
          (json['quantity_requested']?.toString() ?? '0.0').toDouble() ?? 0.0,
      fee: (json['fee']?.toString() ?? '0.0').toDouble() ?? 0.0,
      country: Country.fromJson(json['country'] as Map<String, dynamic>? ?? {}),
      region: Region.fromJson(json['region'] as Map<String, dynamic>? ?? {}),
      shippingAddress: json['shipping_address'] as String? ?? '',
      fullname: json['fullname'] as String? ?? '',
      zipCode: json['zip_code'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      withdrawal_reference: json['withdrawal_reference'] as String?,
      status: RedeemStatusExtension.fromValue(json['status'] as String?),
      createdAt:
          DateTime.tryParse(
            json['created_at'] ?? '',
          )?.toDateTimeFormat(showTime: true) ??
          DateTime.now().toDateTimeFormat(showTime: true) ??
          '',
      updatedAt:
          DateTime.tryParse(
            json['updated_at'] ?? '',
          )?.toDateTimeFormat(showTime: true) ??
          DateTime.now().toDateTimeFormat(showTime: true) ??
          '',

      quoteAmount: (json['quote_amount']?.toString())?.toDouble(),
      quoteCurrency: json['quote_currency'] != null
          ? QuoteCurrency.fromJson(
              json['quote_currency'] as Map<String, dynamic>,
            )
          : null,
      quoteNotes: json['quote_notes'] as String?,
      shippingCost: (json['shipping_cost']?.toString())?.toDouble(),
      estimatedDeliveryDays: json['estimated_delivery_days'] as int?,
      paymentProof: json['payment_proof'] as String?,
      paymentVerified: json['payment_verified'] as bool? ?? false,
      paymentNotes: json['payment_notes'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      carrierCompany: json['carrier_company'] as String?,
      adminNotes: json['admin_notes'] as String?,
      quoteDate:
          DateTime.tryParse(
            json['quote_date'] ?? '',
          )?.toDateTimeFormat(showTime: true) ??
          '',
      acceptedDate:
          DateTime.tryParse(
            json['accepted_date'] ?? '',
          )?.toDateTimeFormat(showTime: true) ??
          '',
      shippedDate:
          DateTime.tryParse(
            json['shipped_date'] ?? '',
          )?.toDateTimeFormat(showTime: true) ??
          '',
      completedDate:
          DateTime.tryParse(
            json['completed_date'] ?? '',
          )?.toDateTimeFormat(showTime: true) ??
          '',
    );
  }

  Redeem copyWith({
    String? reference,
    Asset? asset,
    double? quantityRequested,
    double? fee,
    Country? country,
    Region? region,
    String? shippingAddress,
    String? fullname,
    String? zipCode,
    String? phone,
    RedeemStatus? status,
    String? createdAt,
    String? withdrawal_reference,
    String? updatedAt,
    double? quoteAmount,
    QuoteCurrency? quoteCurrency,
    String? quoteNotes,
    double? shippingCost,
    int? estimatedDeliveryDays,
    String? paymentProof,
    bool? paymentVerified,
    String? paymentNotes,
    String? trackingNumber,
    String? carrierCompany,
    String? adminNotes,
    String? quoteDate,
    String? acceptedDate,
    String? shippedDate,
    String? completedDate,
  }) {
    return Redeem(
      reference: reference ?? this.reference,
      asset: asset ?? this.asset,
      quantityRequested: quantityRequested ?? this.quantityRequested,
      fee: fee ?? this.fee,
      country: country ?? this.country,
      region: region ?? this.region,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      fullname: fullname ?? this.fullname,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      quoteAmount: quoteAmount ?? this.quoteAmount,
      quoteCurrency: quoteCurrency ?? this.quoteCurrency,
      quoteNotes: quoteNotes ?? this.quoteNotes,
      withdrawal_reference: withdrawal_reference ?? this.withdrawal_reference,
      shippingCost: shippingCost ?? this.shippingCost,
      estimatedDeliveryDays:
          estimatedDeliveryDays ?? this.estimatedDeliveryDays,
      paymentProof: paymentProof ?? this.paymentProof,
      paymentVerified: paymentVerified ?? this.paymentVerified,
      paymentNotes: paymentNotes ?? this.paymentNotes,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      carrierCompany: carrierCompany ?? this.carrierCompany,
      adminNotes: adminNotes ?? this.adminNotes,
      quoteDate: quoteDate ?? this.quoteDate,
      acceptedDate: acceptedDate ?? this.acceptedDate,
      shippedDate: shippedDate ?? this.shippedDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'asset': asset.toJson(),
      'quantity_requested': quantityRequested,
      'fee': fee,
      'country': country.toJson(),
      'region': region.toJson(),
      'shipping_address': shippingAddress,
      'fullname': fullname,
      'zip_code': zipCode,
      'phone': phone,
      'status': status.value,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'withdrawal_reference': withdrawal_reference,
      'quote_amount': quoteAmount,
      'quote_currency': quoteCurrency?.toJson(),
      'quote_notes': quoteNotes,
      'shipping_cost': shippingCost,
      'estimated_delivery_days': estimatedDeliveryDays,
      'payment_proof': paymentProof,
      'payment_verified': paymentVerified,
      'payment_notes': paymentNotes,
      'tracking_number': trackingNumber,
      'carrier_company': carrierCompany,
      'admin_notes': adminNotes,
      'quote_date': quoteDate,
      'accepted_date': acceptedDate,
      'shipped_date': shippedDate,
      'completed_date': completedDate,
    };
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  @override
  String toString() {
    return 'Redeem(reference: $reference, status: ${status.label}, quantity: $quantityRequested ${asset.symbol} withdrawal_reference: $withdrawal_reference)';
  }
}
