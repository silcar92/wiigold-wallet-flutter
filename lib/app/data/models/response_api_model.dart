import 'dart:convert';

import 'package:wiigold/app/common/directory/erros.dart';

class ResponseApi {
  final String status;
  final int code;
  final String message;
  final String? message_code;
  final dynamic data;
  final dynamic error;

  ResponseApi({
    this.status = 'error',
    required this.code,
    this.message = '',
    this.message_code,
    this.data,
    this.error,
  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String? ?? 'unknown';
    final code = json['code'] as int? ?? 0;
    final message = json['message'] as String? ?? '';
    final message_code = json['message_code'] as String?;

    final rawData = json['data'];
    final rawError = json['error'];

    return ResponseApi(
      status: status,
      code: code,
      message: message,
      message_code: message_code,
      data: rawData,
      error: rawError,
    );
  }

  ResponseApi copyWith({
    String? status,
    int? code,
    String? message,
    String? message_code,
    dynamic data,
    dynamic error,
    bool clearMessageCode = false,
    bool clearData = false,
    bool clearError = false,
  }) {
    return ResponseApi(
      status: status ?? this.status,
      code: code ?? this.code,
      message: message ?? this.message,
      message_code:
          clearMessageCode ? null : (message_code ?? this.message_code),
      data: clearData ? null : (data ?? this.data),
      error: clearError ? null : (error ?? this.error),
    );
  }

  Map<String, dynamic> toJson() {
    dynamic serializeData(dynamic value) {
      if (value == null) return null;
      if (value is String || value is num || value is bool) return value;
      if (value is List) return value.map((e) => serializeData(e)).toList();
      if (value is Map) {
        return value.map((k, v) => MapEntry(k.toString(), serializeData(v)));
      }

      try {
        return (value as dynamic).toJson();
      } catch (e) {
        try {
          return jsonDecode(jsonEncode(value));
        } catch (_) {
          return value.toString();
        }
      }
    }

    return {
      'status': status,
      'code': code,
      'message': message,
      'message_code': message_code,
      'data': serializeData(data),
      'error': serializeData(error),
    };
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  static ResponseApi connectionError() {
    return ResponseApi(
      status: "error",
      code: 404,
      message: AppErrors.getErrorLabel("CONNECTION_ERROR"),
      message_code: "CONNECTION_ERROR",
      error: 'error',
      data: null,
    );
  }

  static ResponseApi formatExceptionError(FormatException e) {
    return ResponseApi(
      status: "error",
      code: 400,
      message_code: 'ERROR_PARSING_SERVER',
      message: "Error parsing server response.",
      error: e.toString(),
      data: null,
    );
  }

  static ResponseApi unknownError(dynamic e, String endpoint) {
    return ResponseApi(
      status: "error",
      code: 500,
      message: "Client-side error processing request to $endpoint.",
      message_code: "UNKNOWN_ERROR",
      error: e.toString(),
      data: null,
    );
  }

  static ResponseApi unauthorizedError() {
    return ResponseApi(
      code: 401,
      status: 'error',
      message_code: 'UNAUTHORIZED',
      message: 'Tu sesión ha expirado. Por favor, inicia sesión de nuevo.',
    );
  }

  @override
  String toString() {
    return 'ResponseApi(status: $status, code: $code, message: $message, message_code: $message_code, data: $data, error: $error)';
  }
}
