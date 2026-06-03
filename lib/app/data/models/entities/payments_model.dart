import 'dart:convert';

class Payment {
  final String amount_usd;
  final String payment_date;
  final String payment_reference;
  final String proof_payment;
  final String email_user;
  final String rate_usd;
  final String status;
  final String confirmed_at;

  Payment({
    required this.amount_usd,
    required this.payment_date,
    required this.payment_reference,
    required this.proof_payment,
    required this.email_user,
    required this.rate_usd,
    required this.status,
    required this.confirmed_at,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount_usd: json['amount_usd'] ?? '',
      payment_date: json['payment_date'] ?? '',
      payment_reference: json['payment_reference'] ?? '',
      proof_payment: json['proof_payment'] ?? '',
      email_user: json['email_user'] ?? '',
      rate_usd: json['rate_usd'] ?? '',
      status: json['status'] ?? '',
      confirmed_at: json['confirmed_at'] ?? '',
    );
  }

  Payment copyWith({
    String? amount_usd,
    String? payment_date,
    String? payment_reference,
    String? proof_payment,
    String? email_user,
    String? rate_usd,
    String? status,
    String? confirmed_at,
  }) {
    return Payment(
      amount_usd: amount_usd ?? this.amount_usd,
      payment_date: payment_date ?? this.payment_date,
      payment_reference: payment_reference ?? this.payment_reference,
      proof_payment: proof_payment ?? this.proof_payment,
      email_user: email_user ?? this.email_user,
      rate_usd: rate_usd ?? this.rate_usd,
      status: status ?? this.status,
      confirmed_at: confirmed_at ?? this.confirmed_at,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount_usd': amount_usd,
      'payment_date': payment_date,
      'payment_reference': payment_reference,
      'proof_payment': proof_payment,
      'email_user': email_user,
      'rate_usd': rate_usd,
      'status': status,
      'confirmed_at': confirmed_at,
    };
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  @override
  String toString() {
    return 'Payment(amount_usd: $amount_usd, payment_date: $payment_date, payment_reference: $payment_reference, proof_payment: $proof_payment, email_user: $email_user, rate_usd: $rate_usd, status: $status, confirmed_at: $confirmed_at)';
  }
}
