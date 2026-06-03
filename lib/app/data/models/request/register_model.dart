import 'dart:convert';

class Register {
  final String? email;
  final String? password;
  final String? tosVersion;
  final String? privacyVersion;
  final String? personType;

  Register({this.email, this.password, this.tosVersion, this.privacyVersion, this.personType});

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      email: json['email'] as String,
      password: json['password'] ?? '',
      tosVersion: json['tos_version'] as String?,
      privacyVersion: json['privacy_version'] as String?,
      personType: json['person_type'] as String?,
    );
  }

  Register copyWith({String? email, String? password, String? tosVersion, String? privacyVersion, String? personType}) {
    return Register(
      email: email ?? this.email,
      password: password ?? this.password,
      tosVersion: tosVersion ?? this.tosVersion,
      privacyVersion: privacyVersion ?? this.privacyVersion,
      personType: personType ?? this.personType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (tosVersion != null) 'tos_version': tosVersion,
      if (privacyVersion != null) 'privacy_version': privacyVersion,
      'person_type': personType ?? 'natural',
    };
  }

  String toJsonEncode() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return 'Register(email: $email, password: $password, tosVersion: $tosVersion, privacyVersion: $privacyVersion, personType: $personType)';
  }
}
