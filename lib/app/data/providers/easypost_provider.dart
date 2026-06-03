import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wiigold/app/common/utils/logger.dart';

class EasypostEndpoints {
  static const String shipments = '/shipments';
  static const String addresses = '/addresses';
  static const String trackers = '/trackers';
  static const String rates = '/rates';
  static const String retrieveShipment = '/shipments/{id}';
}

class EasypostProvider {
  static const String _baseUrl = 'https://api.easypost.com/v2';
  static const String _apiKey =
      'EZTKe44e5a1ddc874b2f8a7594264bfbd228E89Y34wgafUo30Jr3auRRg';

  final Logger _logger = Logger(module: 'EasypostProvider');

  String _buildUrl(String endpoint) {
    final cleanEndpoint =
        endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '$_baseUrl/$cleanEndpoint';
  }

  Map<String, String> _getHeaders() {
    final String credentials = '$_apiKey:';
    final String encodedCredentials = base64Encode(utf8.encode(credentials));
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'Authorization': 'Basic $encodedCredentials',
    };
  }

  dynamic _processResponse(http.Response response) {
    final dynamic body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final String errorMessage =
          body['error']?['message'] ?? 'Unknown API error from Easypost';

      _logger.log(
        label: 'easypostApiError',
        content: 'Status: ${response.statusCode}, Body: ${response.body}',
      );

      throw HttpException(
        'Error ${response.statusCode}: $errorMessage',
        uri: response.request?.url,
      );
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      _buildUrl(endpoint),
    ).replace(queryParameters: queryParams);
    try {
      final response = await http.get(uri, headers: _getHeaders());

      return _processResponse(response);
    } on SocketException catch (e, s) {
      await _logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'easypostGetSocket',
        reason: 'Network connection error during GET request to Easypost.',
        customData: {'endpoint': endpoint},
      );

      throw const HttpException(
        'Connection error. Please check your internet connection.',
      );
    } on FormatException catch (e, s) {
      await _logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'easypostGetFormat',
        reason: 'Invalid JSON response from Easypost server.',
        customData: {'endpoint': endpoint},
      );

      throw const HttpException('Invalid response from the server.');
    } catch (e, s) {
      if (e is! HttpException) {
        await _logger.crashlyticsError(
          error: e,
          stackTrace: s,
          tag: 'easypostGetUnknown',
          reason: 'Unknown error during Easypost GET request.',
          customData: {'endpoint': endpoint},
        );
      }
      rethrow;
    }
  }

  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    final url = _buildUrl(endpoint);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: jsonEncode(body),
      );

      return _processResponse(response);
    } on SocketException catch (e, s) {
      await _logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'easypostPostSocket',
        reason: 'Network connection error during POST request to Easypost.',
        customData: {'endpoint': endpoint},
      );

      throw const HttpException(
        'Connection error. Please check your internet connection.',
      );
    } on FormatException catch (e, s) {
      await _logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'easypostPostFormat',
        reason: 'Invalid JSON response from Easypost server.',
        customData: {'endpoint': endpoint},
      );

      throw const HttpException('Invalid response from the server.');
    } catch (e, s) {
      if (e is! HttpException) {
        await _logger.crashlyticsError(
          error: e,
          stackTrace: s,
          tag: 'easypostPostUnknown',
          reason: 'Unknown error during Easypost POST request.',
          customData: {'endpoint': endpoint},
        );
      }

      rethrow;
    }
  }
}
