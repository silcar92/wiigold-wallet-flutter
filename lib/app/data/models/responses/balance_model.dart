import 'dart:convert';

import 'package:wiigold/app/common/utils/extensions.dart';

class RateChange {
  final String? oldRate;
  final String? currentRate;
  final double? variation;
  final String? changeType;

  RateChange({this.oldRate, this.currentRate, this.variation, this.changeType});

  factory RateChange.fromJson(Map<String, dynamic> json) {
    return RateChange(
      oldRate: json['old_rate'] as String?,
      currentRate: json['current_rate'] as String?,
      variation: (json['variation'] as num?)?.toDouble(),
      changeType: json['change_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'old_rate': oldRate,
      'current_rate': currentRate,
      'variation': variation,
      'change_type': changeType,
    };
  }

  RateChange copyWith({
    String? oldRate,
    String? currentRate,
    double? variation,
    String? changeType,
  }) {
    return RateChange(
      oldRate: oldRate ?? this.oldRate,
      currentRate: currentRate ?? this.currentRate,
      variation: variation ?? this.variation,
      changeType: changeType ?? this.changeType,
    );
  }

  @override
  String toString() {
    return 'RateChange(oldRate: $oldRate, currentRate: $currentRate, variation: $variation, changeType: $changeType)';
  }
}

class AssetInfo {
  final String? name;
  final String? code;
  final String? type;
  final String? symbol;
  final String? numeric_code;
  final String? asset_image_url;
  final bool? is_withdrawable;
  final int? precision;
  final int? scale;
  final String? description;
  final RateChange? rateChange;

  AssetInfo({
    this.name,
    this.code,
    this.type,
    this.symbol,
    this.numeric_code,
    this.asset_image_url,
    this.is_withdrawable,
    this.precision,
    this.scale,
    this.description,
    this.rateChange,
  });

  factory AssetInfo.fromJson(Map<String, dynamic> json) {
    return AssetInfo(
      name: json['name'] as String?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      symbol: json['symbol'] as String?,
      asset_image_url: json['asset_image_url'] as String?,
      numeric_code: json['numeric_code'] as String?,
      precision: json['precision'] as int?,
      scale: json['scale'] as int?,
      is_withdrawable: json['is_withdrawable'] as bool?,
      description: json['description'] as String?,
      rateChange:
          json['rate_change'] != null
              ? RateChange.fromJson(json['rate_change'] as Map<String, dynamic>)
              : null,
    );
  }

  AssetInfo copyWith({
    String? name,
    String? code,
    String? type,
    String? symbol,
    String? numeric_code,
    String? asset_image_url,
    int? precision,
    int? scale,
    String? description,
    bool? is_withdrawable,
    RateChange? rateChange,
  }) {
    return AssetInfo(
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      symbol: symbol ?? this.symbol,
      asset_image_url: asset_image_url ?? this.asset_image_url,
      numeric_code: numeric_code ?? this.numeric_code,
      precision: precision ?? this.precision,
      scale: scale ?? this.scale,
      is_withdrawable: is_withdrawable ?? this.is_withdrawable,
      description: description ?? this.description,
      rateChange: rateChange ?? this.rateChange,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'type': type,
      'symbol': symbol,
      'asset_image_url': asset_image_url,
      'numeric_code': numeric_code,
      'precision': precision,
      'is_withdrawable': is_withdrawable,
      'scale': scale,
      'description': description,
      'rate_change': rateChange?.toJson(),
    };
  }

  @override
  String toString() {
    return 'AssetInfo(name: $name, code: $code, type: $type, symbol: $symbol, numeric_code: $numeric_code, asset_image_url: $asset_image_url, precision: $precision, scale: $scale, description: $description, rateChange: $rateChange, is_withdrawable: $is_withdrawable)';
  }
}

class AssetBalance {
  final String? asset_code;
  final AssetInfo? asset_info;
  final String? total;
  final String? balance;
  final String? available;
  final String? pending;
  final String? frozen;
  final String? locked_amount;
  final String? staked;
  final String? block_height;
  final String? block_hash;

  AssetBalance({
    this.asset_code,
    this.asset_info,
    this.total,
    this.balance,
    this.available,
    this.pending,
    this.frozen,
    this.locked_amount,
    this.staked,
    this.block_height,
    this.block_hash,
  });

  factory AssetBalance.fromJson(Map<String, dynamic> json) {
    return AssetBalance(
      asset_code: json['asset_code'] as String?,
      asset_info:
          json['asset_info'] != null
              ? AssetInfo.fromJson(json['asset_info'] as Map<String, dynamic>)
              : null,
      total: json['total'] as String?,
      balance: json['balance'] as String?,
      available: (json['available'] as String?)?.toHauvNumericString(),
      pending: json['pending'] as String?,
      frozen: json['frozen'] as String?,
      locked_amount: json['locked_amount'] as String?,
      staked: json['staked'] as String?,
      block_height: json['block_height'] as String?,
      block_hash: json['block_hash'] as String?,
    );
  }

  AssetBalance copyWith({
    String? asset_code,
    AssetInfo? asset_info,
    String? total,
    String? balance,
    String? available,
    String? pending,
    String? frozen,
    String? locked_amount,
    String? staked,
    String? block_height,
    String? block_hash,
  }) {
    return AssetBalance(
      asset_code: asset_code ?? this.asset_code,
      asset_info: asset_info ?? this.asset_info,
      total: total ?? this.total,
      balance: balance ?? this.balance,
      available: available ?? this.available,
      pending: pending ?? this.pending,
      frozen: frozen ?? this.frozen,
      locked_amount: locked_amount ?? this.locked_amount,
      staked: staked ?? this.staked,
      block_height: block_height ?? this.block_height,
      block_hash: block_hash ?? this.block_hash,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_code': asset_code,
      'asset_info': asset_info?.toJson(),
      'total': total,
      'balance': balance,
      'available': available,
      'pending': pending,
      'frozen': frozen,
      'locked_amount': locked_amount,
      'staked': staked,
      'block_height': block_height,
      'block_hash': block_hash,
    };
  }

  String toJsonEncode() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return 'AssetBalance(asset_code: $asset_code, asset_info: $asset_info, total: $total, balance: $balance, available: $available, pending: $pending, frozen: $frozen, locked_amount: $locked_amount, staked: $staked, block_height: $block_height, block_hash: $block_hash)';
  }
}
