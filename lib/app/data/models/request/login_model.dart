import 'dart:convert';

class Login {
  final String? email;
  final String? password;
  final String? token_fcm;

  Login({this.email, this.password, this.token_fcm});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'] as String,
      password: json['password'] as String,
      token_fcm: json['token_fcm'] as String?,
    );
  }

  Login copyWith({String? email, String? password, String? token_fcm}) {
    return Login(
      email: email ?? this.email,
      password: password ?? this.password,
      token_fcm: token_fcm ?? this.token_fcm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email ?? '',
      'password': password ?? '',
      'token_fcm': token_fcm ?? '',
    };
  }

  String toJsonEncode() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return 'Login(email: $email, password: $password, token_fcm: $token_fcm)';
  }
}
