import 'dart:convert';

class Transaction {
  final String transactionId;
  final String date;
  final String time;
  final String operationType;
  final String status;
  final dynamic details;
  final double fee;
  final double amount;

  Transaction({
    required this.transactionId,
    required this.date,
    required this.time,
    /*
       TRANSFER = 'transfer', 'Transferencia'
       EXTERNAL_TRANSFER = 'external_transfer', 'Transferencia Externa'
       DEPOSIT = 'deposit', 'Depósito'
       SWAP = 'swap', 'Swap'
     */
    required this.operationType,
    /*
       PENDING = 'pending', 'Pendiente'
       COMPLETED = 'completed', 'Completado'
       FAILED = 'failed', 'Fallido'
       CANCELLED = 'cancelled', 'Cancelado'
     */
    required this.status,
    this.details,
    required this.fee,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      operationType: json['operationType'] as String,
      status: json['status'] as String,
      details: json['details'] as dynamic,
      fee: (json['fee'] ?? 0.0) as double,
      amount: json['amount'] as double,
    );
  }

  Transaction copyWith({
    String? transactionId,
    String? date,
    String? time,
    String? operationType,
    String? status,
    dynamic details,
    double? fee,
    double? amount,
  }) {
    return Transaction(
      transactionId: transactionId ?? this.transactionId,
      date: date ?? this.date,
      time: time ?? this.time,
      operationType: operationType ?? this.operationType,
      status: status ?? this.status,
      details: details ?? this.details,
      fee: fee ?? this.fee,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'date': date,
      'time': time,
      'operationType': operationType,
      'status': status,
      'details': details,
      'fee': fee,
      'amount': amount,
    };
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  Map<String, String> toGetNamedParameters({
    required String viewMode,
    required String appbarTitle,
    Map<String, dynamic>? data,
    Map<String, dynamic>? customExtra,
    Map<String, dynamic>? transactionExtra,
  }) {
    final params = <String, String>{
      'viewMode': viewMode,
      'appbarTitle': appbarTitle,
      'transaction': toJsonEncode(),
    };

    if (data != null) {
      params['data'] = json.encode(data);
    }

    if (customExtra != null) {
      params['useCustomExtra'] = 'true';
      params['customExtra'] = json.encode(customExtra);
    } else {
      params['useCustomExtra'] = 'false';
    }

    if (transactionExtra != null) {
      params['useTransactionExtra'] = 'true';
      params['transactionExtra'] = json.encode(transactionExtra);
    } else {
      params['transactionExtra'] = 'false';
    }

    return params;
  }

  @override
  String toString() {
    return 'Transaction(transactionId: $transactionId, date: $date, time: $time, operationType: $operationType, status: $status, details: $details, fee: $fee, amount: $amount)';
  }
}
