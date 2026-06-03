import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:wiigold/app/common/utils/logger.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_toast.dart';
import 'package:wiigold/app/routers/app_routes.dart';
import 'package:wiigold/app/common/directory/erros.dart';
import 'package:wiigold/app/common/directory/success.dart';
import 'package:wiigold/app/data/models/response_api_model.dart';
import 'package:wiigold/app/data/storage/token_storage.dart';
import 'package:wiigold/config/environment.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiProvider {
  final TokenStorage _tokenStorage = TokenStorage();
  final Logger logger = Logger(module: "ApiProvider");

  static bool _isRedirecting = false;

  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };

  ApiProvider();

  String _baseUrl(String endpoint) {
    final cleanBaseUrl = EnvironmentConfig.apiUrl.endsWith('/')
        ? EnvironmentConfig.apiUrl.substring(
            0,
            EnvironmentConfig.apiUrl.length - 1,
          )
        : EnvironmentConfig.apiUrl;

    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';

    logger.log(enable: true, content: "url: ${cleanBaseUrl + cleanEndpoint}");

    return cleanBaseUrl + cleanEndpoint;
  }

  Map<String, String> _formatHeaders({
    List<Map<String, String>>? customHeaders,
  }) {
    final Map<String, String> headers = {..._baseHeaders};
    final String token = _tokenStorage.getCurrentToken();

    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (customHeaders != null) {
      for (final h in customHeaders) {
        headers.addAll(h);
      }
    }

    return headers;
  }

  ResponseApi _formatResponse(http.Response resp) {
    logger.log(enable: true, content: "pure resp: ${resp.body}");

    final String responseBodyString = utf8.decode(resp.bodyBytes);
    final dynamic jsonResponse = jsonDecode(responseBodyString);

    if (jsonResponse['message'] == "TOKEN_UNAUTHORIZED") {
      if (!_isRedirecting) {
        _isRedirecting = true;

        logger.log(
          label: 'TOKEN_UNAUTHORIZED Detected',
          content: 'Redirecting to login...',
        );

        DynamicToast.error(
          title: 'others.session_expired_title'.tr,
          description: "others.session_expired_subtitle".tr,
        );

        _tokenStorage.deleteCurrentToken();
        Get.offAllNamed(AppRoutes.LOGIN);

        Future.delayed(
          const Duration(seconds: 5),
          () => _isRedirecting = false,
        );
      }

      return ResponseApi.unauthorizedError();
    }

    final ResponseApi responseApi = ResponseApi(
      code: resp.statusCode,
      message_code: jsonResponse['message'],
      error: jsonResponse['error'] ?? 'error',
      data: jsonResponse['data'] ?? 'data',
    );

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      return responseApi.copyWith(
        status: "error",
        message: AppErrors.getErrorLabel(jsonResponse['message']),
        error: jsonResponse['error'],
      );
    }

    return responseApi.copyWith(
      status: "success",
      message: AppSuccess.getSuccessLabel(jsonResponse['message']),
    );
  }

  Future<http.Response> executeGet({
    required String endpoint,
    List<Map<String, String>> headers = const [],
    Map<String, dynamic> queryParams = const {},
    Map<String, dynamic> pathParams = const {},
    bool useCustonUrl = false,
  }) async {
    try {
      String baseUrl = endpoint;

      if (pathParams.isNotEmpty) {}

      final String url = useCustonUrl ? baseUrl : _baseUrl(baseUrl);

      Uri finalUri = Uri.parse(url);

      if (queryParams.isNotEmpty) {
        finalUri = finalUri.replace(
          queryParameters: queryParams.map(
            (k, v) => MapEntry(k, v?.toString() ?? ''),
          ),
        );
      }

      return await http.get(
        finalUri,
        headers: _formatHeaders(customHeaders: headers),
      );
    } on SocketException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executeGet',
        reason: 'Error de conexión de red (SocketException).',
        customData: {'endpoint': endpoint},
      );
      return http.Response(jsonEncode({'message': 'NETWORK_ERROR'}), 503);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executeGet',
        reason: 'Error inesperado en la capa de ejecución GET.',
        customData: {'endpoint': endpoint, 'queryParams': queryParams},
      );
      return http.Response(jsonEncode({'message': 'UNKNOWN_ERROR'}), 500);
    }
  }

  Future<http.Response> executePost({
    required String endpoint,
    required Map<String, dynamic> data,
    List<Map<String, String>>? headers,
    bool useCustonUrl = false,
  }) async {
    try {
      final String url = useCustonUrl ? endpoint : _baseUrl(endpoint);
      return await http.post(
        Uri.parse(url),
        headers: _formatHeaders(customHeaders: headers),
        body: jsonEncode(data),
      );
    } on SocketException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executePost',
        reason: 'Error de conexión de red (SocketException).',
        customData: {'endpoint': endpoint},
      );
      return http.Response(jsonEncode({'message': 'NETWORK_ERROR'}), 503);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executePost',
        reason: 'Error inesperado en la capa de ejecución POST.',
        customData: {'endpoint': endpoint},
      );
      return http.Response(jsonEncode({'message': 'UNKNOWN_ERROR'}), 500);
    }
  }

  Future<http.Response> executePatch({
    required String endpoint,
    required Map<String, dynamic> data,
    List<Map<String, String>>? headers,
    bool useCustonUrl = false,
  }) async {
    try {
      final String url = useCustonUrl ? endpoint : _baseUrl(endpoint);
      return await http.patch(
        Uri.parse(url),
        headers: _formatHeaders(customHeaders: headers),
        body: jsonEncode(data),
      );
    } on SocketException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executePatch',
        reason: 'Error de conexión de red (SocketException).',
        customData: {'endpoint': endpoint},
      );
      return http.Response(jsonEncode({'message': 'NETWORK_ERROR'}), 503);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executePatch',
        reason: 'Error inesperado en la capa de ejecución PATCH.',
        customData: {'endpoint': endpoint},
      );
      return http.Response(jsonEncode({'message': 'UNKNOWN_ERROR'}), 500);
    }
  }

  Future<ResponseApi> genericGet(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? pathParams,
  }) async {
    try {
      final http.Response response = await executeGet(
        endpoint: endpoint,
        queryParams: queryParams ?? {},
        pathParams: pathParams ?? {},
      );

      return _formatResponse(response);
    } on FormatException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'genericGet.FormatException',
        reason: 'Fallo al decodificar la respuesta JSON del servidor.',
        customData: {'endpoint': endpoint},
      );
      return ResponseApi.formatExceptionError(e);
    } catch (err, s) {
      await logger.crashlyticsError(
        error: err,
        stackTrace: s,
        tag: 'genericGet.UnknownError',
        reason: 'Error inesperado durante la petición GET.',
        customData: {'endpoint': endpoint, 'queryParams': queryParams},
      );
      return ResponseApi.unknownError(err, endpoint);
    }
  }

  Future<ResponseApi> genericPost(String endpoint, dynamic body) async {
    try {
      Map<String, dynamic> requestData;

      if (body == null) {
        requestData = {};
      } else if (body is Map) {
        requestData = Map<String, dynamic>.from(body);
      } else {
        requestData = (body as dynamic).toJson();
      }

      final http.Response response = await executePost(
        endpoint: endpoint,
        data: requestData,
      );
      return _formatResponse(response);
    } on FormatException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'genericPost.FormatException',
        reason: 'Fallo al decodificar la respuesta JSON del servidor.',
        customData: {'endpoint': endpoint},
      );
      return ResponseApi.formatExceptionError(e);
    } catch (err, s) {
      await logger.crashlyticsError(
        error: err,
        stackTrace: s,
        tag: 'genericPost.UnknownError',
        reason: 'Error inesperado durante la petición POST.',
        customData: {
          'endpoint': endpoint,
          'body_type': body?.runtimeType.toString() ?? 'null',
        },
      );
      return ResponseApi.unknownError(err, endpoint);
    }
  }

  Future<http.Response> executeMultipart({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, List<int>>? fileBytes,
    Map<String, String>? fileNames,
    Map<String, String>? contentTypes,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl(endpoint));
      final request = http.MultipartRequest('POST', uri);

      final headers = _formatHeaders();
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      request.fields.addAll(fields);

      if (fileBytes != null) {
        for (final entry in fileBytes.entries) {
          final name = fileNames?[entry.key] ?? entry.key;
          final mime = contentTypes?[entry.key] ?? 'application/octet-stream';
          final parts = mime.split('/');
          request.files.add(
            http.MultipartFile.fromBytes(
              entry.key,
              entry.value,
              filename: name,
              contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'octet-stream'),
            ),
          );
        }
      }

      final streamed = await request.send();
      return await http.Response.fromStream(streamed);
    } on SocketException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executeMultipart',
        reason: 'Error de red en multipart POST.',
        customData: {'endpoint': endpoint},
      );
      return http.Response(jsonEncode({'message': 'NETWORK_ERROR'}), 503);
    } catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'executeMultipart',
        reason: 'Error inesperado en multipart POST.',
        customData: {'endpoint': endpoint},
      );
      return http.Response(jsonEncode({'message': 'UNKNOWN_ERROR'}), 500);
    }
  }

  Future<ResponseApi> genericPostMultipart({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, List<int>>? fileBytes,
    Map<String, String>? fileNames,
    Map<String, String>? contentTypes,
  }) async {
    try {
      final response = await executeMultipart(
        endpoint: endpoint,
        fields: fields,
        fileBytes: fileBytes,
        fileNames: fileNames,
        contentTypes: contentTypes,
      );
      return _formatResponse(response);
    } catch (err, s) {
      await logger.crashlyticsError(
        error: err,
        stackTrace: s,
        tag: 'genericPostMultipart.UnknownError',
        reason: 'Error inesperado en multipart POST.',
        customData: {'endpoint': endpoint},
      );
      return ResponseApi.unknownError(err, endpoint);
    }
  }

  Future<ResponseApi> genericDelete(String endpoint) async {
    try {
      final uri = Uri.parse(_baseUrl(endpoint));
      final response = await http.delete(uri, headers: _formatHeaders());
      return _formatResponse(response);
    } on SocketException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'genericDelete.SocketException',
        reason: 'Error de red en DELETE.',
        customData: {'endpoint': endpoint},
      );
      return ResponseApi.unknownError(e, endpoint);
    } catch (err, s) {
      await logger.crashlyticsError(
        error: err,
        stackTrace: s,
        tag: 'genericDelete.UnknownError',
        reason: 'Error inesperado en DELETE.',
        customData: {'endpoint': endpoint},
      );
      return ResponseApi.unknownError(err, endpoint);
    }
  }

  Future<ResponseApi> genericPatch(String endpoint, dynamic body) async {
    try {
      Map<String, dynamic> requestData;

      if (body == null) {
        requestData = {};
      } else if (body is Map) {
        requestData = Map<String, dynamic>.from(body);
      } else {
        requestData = (body as dynamic).toJson();
      }

      final http.Response response = await executePatch(
        endpoint: endpoint,
        data: requestData,
      );

      return _formatResponse(response);
    } on FormatException catch (e, s) {
      await logger.crashlyticsError(
        error: e,
        stackTrace: s,
        tag: 'genericPatch.FormatException',
        reason: 'Fallo al decodificar la respuesta JSON del servidor.',
        customData: {'endpoint': endpoint},
      );

      return ResponseApi.formatExceptionError(e);
    } catch (err, s) {
      await logger.crashlyticsError(
        error: err,
        stackTrace: s,
        tag: 'genericPatch.UnknownError',
        reason: 'Error inesperado durante la petición PATCH.',
        customData: {
          'endpoint': endpoint,
          'body_type': body?.runtimeType.toString() ?? 'null',
        },
      );

      return ResponseApi.unknownError(err, endpoint);
    }
  }
}
