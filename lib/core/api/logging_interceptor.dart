import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Dio interceptor that logs HTTP requests and responses in debug mode.
/// Request: method, URI, headers (Authorization redacted), body.
/// Response: status code, response data (truncated if large).
/// Error: message and response body if present.
class LoggingInterceptor extends Interceptor {
  static const int _maxBodyLogLength = 800;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(options);
      return;
    }
    final headers = Map<String, dynamic>.from(options.headers);
    if (headers.containsKey('Authorization')) {
      headers['Authorization'] = '<redacted>';
    }
    final body = options.data != null ? _stringify(options.data) : null;
    debugPrint(
      '[HTTP] → ${options.method} ${options.uri}\n'
      '  Headers: $headers\n'
      '${body != null ? '  Body: ${_truncate(body)}\n' : ''}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!kDebugMode) {
      handler.next(response);
      return;
    }
    final dataStr = response.data != null
        ? _truncate(_stringify(response.data))
        : '<empty>';
    debugPrint(
      '[HTTP] ← ${response.statusCode} ${response.requestOptions.uri}\n'
      '  Data: $dataStr\n',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(err);
      return;
    }
    final response = err.response;
    final dataStr = response?.data != null
        ? _truncate(_stringify(response!.data))
        : null;
    debugPrint(
      '[HTTP] ✗ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      '  Error: ${err.message}\n'
      '  Type: ${err.type}\n'
      '${response != null ? '  Status: ${response.statusCode}\n' : ''}'
      '${dataStr != null ? '  Response: $dataStr\n' : ''}',
    );
    handler.next(err);
  }

  static String _stringify(dynamic data) {
    if (data is String) return data;
    if (data is Map || data is List) return data.toString();
    return data?.toString() ?? 'null';
  }

  static String _truncate(String s) {
    if (s.length <= _maxBodyLogLength) return s;
    return '${s.substring(0, _maxBodyLogLength)}... (${s.length} chars)';
  }
}
