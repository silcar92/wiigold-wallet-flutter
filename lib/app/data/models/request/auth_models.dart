import 'dart:convert';

class AuthUser {
  final int country_id;
  final int region_id;
  final String address;
  final String postal_code;

  AuthUser({
    required this.country_id,
    required this.region_id,
    required this.address,
    required this.postal_code,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      country_id: json['country_id'] as int,
      region_id: json['region_id'] as int,
      address: json['address'] as String,
      postal_code: json['postal_code'] as String,
    );
  }

  AuthUser copyWith({
    int? country_id,
    int? region_id,
    String? address,
    String? postal_code,
  }) {
    return AuthUser(
      country_id: country_id ?? this.country_id,
      region_id: region_id ?? this.region_id,
      address: address ?? this.address,
      postal_code: postal_code ?? this.postal_code,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_id': country_id,
      'region_id': region_id,
      'address': address,
      'postal_code': postal_code,
    };
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  @override
  String toString() {
    return 'AuthUser(country_id: $country_id, region_id: $region_id, address: $address, postal_code: $postal_code)';
  }
}
