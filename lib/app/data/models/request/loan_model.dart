import 'dart:convert';

class LoanData {
  final double? amountUsd;
  final String? codeAsset;
  final String? uuidTermDays;

  LoanData({this.amountUsd, this.codeAsset, this.uuidTermDays});

  LoanData copyWith({
    double? amountUsd,
    String? codeAsset,
    String? uuidTermDays,
  }) {
    return LoanData(
      amountUsd: amountUsd ?? this.amountUsd,
      codeAsset: codeAsset ?? this.codeAsset,
      uuidTermDays: uuidTermDays ?? this.uuidTermDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount_usd': amountUsd ?? '',
      'code_asset': codeAsset ?? '',
      'uuid_term_days': uuidTermDays ?? '',
    };
  }

  factory LoanData.fromJson(Map<String, dynamic> json) {
    return LoanData(
      amountUsd: (json['amount_usd'] as num).toDouble() ?? 0,
      codeAsset: json['code_asset'] as String?,
      uuidTermDays: json['uuid_term_days'] as String?,
    );
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  factory LoanData.fromJsonString(String source) {
    return LoanData.fromJson(json.decode(source));
  }

  @override
  String toString() {
    return 'LoanData(amountUsd: $amountUsd, codeAsset: $codeAsset, uuidTermDays: $uuidTermDays)';
  }
}

class LoanTerm {
  final String uuid;
  final int termDays;
  final double interestRate;

  LoanTerm({
    required this.uuid,
    required this.termDays,
    required this.interestRate,
  });

  LoanTerm copyWith({String? uuid, int? termDays, double? interestRate}) {
    return LoanTerm(
      uuid: uuid ?? this.uuid,
      termDays: termDays ?? this.termDays,
      interestRate: interestRate ?? this.interestRate,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uuid': uuid, 'term_days': termDays, 'interest_rate': interestRate};
  }

  factory LoanTerm.fromJson(Map<String, dynamic> json) {
    return LoanTerm(
      uuid: json['uuid'] as String,
      termDays: json['term_days'] as int,

      interestRate: (json['interest_rate'] as num).toDouble(),
    );
  }

  String toJsonEncode() => json.encode(toJson());

  factory LoanTerm.fromJsonString(String source) =>
      LoanTerm.fromJson(json.decode(source));

  @override
  String toString() {
    return 'LoanTerm(uuid: $uuid, termDays: $termDays, interestRate: $interestRate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoanTerm &&
        other.uuid == uuid &&
        other.termDays == termDays &&
        other.interestRate == interestRate;
  }

  @override
  int get hashCode => uuid.hashCode ^ termDays.hashCode ^ interestRate.hashCode;
}
