import 'dart:convert';

class User {
  final String? first_name;
  final String? last_name;
  late final String email;
  final String? phone_literal;
  final String? phone_number;
  final int? country_id;
  final int? region_id;
  final String? address;
  final String? postal_code;
  final String? date_of_birth;
  final String? identification_number;
  final String? wallet_address;
  final String? kyc_provider_status;
  final String? compliance_status;
  final String? person_type;
  final String? kyb_step;
  final String? kyb_status;
  final String? company_trading_name;
  final String? company_legal_name;

  User({
    required this.email,
    this.first_name,
    this.last_name,
    this.phone_literal,
    this.phone_number,
    this.country_id,
    this.region_id,
    this.address,
    this.postal_code,
    this.date_of_birth,
    this.identification_number,
    this.wallet_address,
    this.kyc_provider_status,
    this.compliance_status,
    this.person_type,
    this.kyb_step,
    this.kyb_status,
    this.company_trading_name,
    this.company_legal_name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      email: json['email'] as String,
      phone_literal: json['phone_literal'] as String? ?? '',
      phone_number: json['phone_number'] as String? ?? '',
      country_id: json['country_id'] as int?,
      region_id: json['region_id'] as int?,
      address: json['address'] as String? ?? '',
      postal_code: json['postal_code'] as String? ?? '',
      date_of_birth: json['date_of_birth'] as String? ?? '',
      identification_number: json['identification_number'] as String? ?? '',
      wallet_address: json['wallet_address'] as String? ?? '',
      kyc_provider_status: json['kyc_provider_status'] as String? ?? '',
      compliance_status: json['compliance_status'] is Map
          ? (json['compliance_status'] as Map)['code']?.toString()
          : json['compliance_status']?.toString(),
      person_type: json['person_type'] as String?,
      kyb_step: json['kyb_step'] as String?,
      kyb_status: json['kyb_status'] as String?,
      company_trading_name: json['company_trading_name'] as String?,
      company_legal_name: json['company_legal_name'] as String?,
    );
  }

  User copyWith({
    String? first_name,
    String? last_name,
    String? email,
    String? phone_literal,
    String? phone_number,
    int? country_id,
    int? region_id,
    String? address,
    String? postal_code,
    String? date_of_birth,
    String? identification_number,
    String? wallet_address,
    String? kyc_provider_status,
    String? compliance_status,
    String? person_type,
    String? kyb_step,
    String? kyb_status,
    String? company_trading_name,
    String? company_legal_name,
  }) {
    return User(
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      phone_literal: phone_literal ?? this.phone_literal,
      phone_number: phone_number ?? this.phone_number,
      country_id: country_id ?? this.country_id,
      region_id: region_id ?? this.region_id,
      address: address ?? this.address,
      postal_code: postal_code ?? this.postal_code,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      identification_number:
          identification_number ?? this.identification_number,
      wallet_address: wallet_address ?? this.wallet_address,
      kyc_provider_status: kyc_provider_status ?? this.kyc_provider_status,
      compliance_status: compliance_status ?? this.compliance_status,
      person_type: person_type ?? this.person_type,
      kyb_step: kyb_step ?? this.kyb_step,
      kyb_status: kyb_status ?? this.kyb_status,
      company_trading_name: company_trading_name ?? this.company_trading_name,
      company_legal_name: company_legal_name ?? this.company_legal_name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "phone_literal": phone_literal,
      "phone_number": phone_number,
      "country_id": country_id,
      "region_id": region_id,
      "address": address,
      "postal_code": postal_code,
      "date_of_birth": date_of_birth,
      "identification_number": identification_number,
      "wallet_address": wallet_address,
      "kyc_provider_status": kyc_provider_status,
      "compliance_status": compliance_status,
      "person_type": person_type,
      "kyb_step": kyb_step,
      "kyb_status": kyb_status,
      "company_trading_name": company_trading_name,
      "company_legal_name": company_legal_name,
    };
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  @override
  String toString() {
    return 'User(first_name: $first_name, last_name: $last_name, email: $email, phone_literal: $phone_literal, phone_number: $phone_number, country_id: $country_id, region_id: $region_id, address: $address, postal_code: $postal_code, date_of_birth: $date_of_birth, identification_number: $identification_number, wallet_address: $wallet_address, kyc_provider_status: $kyc_provider_status, compliance_status: $compliance_status, person_type: $person_type, kyb_step: $kyb_step, kyb_status: $kyb_status)';
  }
}
