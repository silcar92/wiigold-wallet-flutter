import 'dart:convert';

class PaymentMethodType {
  final String id;
  final String name;
  final String description;
  final String iconUrl;

  PaymentMethodType({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
  });

  factory PaymentMethodType.fromJson(Map<String, dynamic> json) {
    return PaymentMethodType(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconUrl: json['icon_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
    };
  }

  PaymentMethodType copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
  }) {
    return PaymentMethodType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  String toString() {
    return 'PaymentMethodType(id: $id, name: $name, iconUrl: $iconUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethodType &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.iconUrl == iconUrl;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ iconUrl.hashCode;
}

class PaymentMethod {
  final String paymentMethodId;
  final PaymentMethodType paymentMethodType;
  final Currency? currency;
  final Bank? bank;
  final String? accountNumber;
  final String? accountName;
  final String? documentNumber;
  final String? email;

  PaymentMethod({
    required this.paymentMethodId,
    required this.paymentMethodType,
    this.currency,
    this.bank,
    this.accountNumber,
    this.accountName,
    this.documentNumber,
    this.email,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodId: json['payment_method_id'] as String? ?? '',
      paymentMethodType: PaymentMethodType.fromJson(
        json['payment_method_type'] as Map<String, dynamic>? ?? {},
      ),
      currency: json['currency'] != null
          ? Currency.fromJson(json['currency'] as Map<String, dynamic>)
          : null,
      bank: json['bank'] != null
          ? Bank.fromJson(json['bank'] as Map<String, dynamic>)
          : null,
      accountNumber: json['account_number'] as String? ?? '',
      accountName: json['account_name'] as String? ?? '',
      documentNumber: json['document_number'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_method_id': paymentMethodId,
      'payment_method_type': paymentMethodType.toJson(),
      'currency': currency?.toJson(),
      'bank': bank?.toJson(),
      'accountNumber': accountNumber?.toString(),
      'accountName': accountName?.toString(),
      'documentNumber': documentNumber?.toString(),
      'email': email?.toString(),
    };
  }

  String toJsonEncode() => json.encode(toJson());

  factory PaymentMethod.fromJsonString(String source) =>
      PaymentMethod.fromJson(json.decode(source) as Map<String, dynamic>);

  PaymentMethod copyWith({
    String? paymentMethodId,
    PaymentMethodType? paymentMethodType,
    Currency? currency,
    Bank? bank,
    String? accountNumber,
    String? accountName,
    String? documentNumber,
    String? email,
  }) {
    return PaymentMethod(
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      paymentMethodType: paymentMethodType ?? this.paymentMethodType,
      currency: currency ?? this.currency,
      bank: bank ?? this.bank,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      documentNumber: documentNumber ?? this.documentNumber,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'PaymentMethod(id: $paymentMethodId, type: ${paymentMethodType.name}, bank: $bank, currency: $currency)';
  }
}

class Currency {
  final String? name;
  final String? code;

  Currency({this.name, this.code});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      name: json['name'] as String?,
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code};
  }
}

class Bank {
  final String? name;
  final String? swiftCode;

  Bank({this.name, this.swiftCode});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'] as String?,
      swiftCode: json['swift_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, "swift_code": swiftCode};
  }
}
