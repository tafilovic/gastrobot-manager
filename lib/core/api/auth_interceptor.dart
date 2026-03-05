import 'package:dio/dio.dart';

import 'api_config.dart';
import 'token_store.dart';

/// Dio interceptor that:
/// - Injects `Authorization: Bearer <token>` on every outgoing request.
/// - On a 401 response, calls `POST /auth/refresh`, updates [TokenStore],
///   persists via [onTokensRefreshed], then retries the original request once.
/// - If the refresh also fails, calls [onLogout] and propagates the error.
///
/// Uses [QueuedInterceptorsWrapper] so concurrent requests during a refresh
/// are queued and retried with the new token — no duplicate refresh calls.
class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor({
    required TokenStore tokenStore,
    required Future<void> Function(String accessToken, String refreshToken)
        onTokensRefreshed,
    required Future<void> Function() onLogout,
  })  : _tokenStore = tokenStore,
        _onTokensRefreshed = onTokensRefreshed,
        _onLogout = onLogout;

  final TokenStore _tokenStore;
  final Future<void> Function(String, String) _onTokensRefreshed;
  final Future<void> Function() _onLogout;

  // Plain Dio used only for the refresh call — never goes through this interceptor.
  static final Dio _refreshDio = Dio(
    BaseOptions(baseUrl: ApiConfig.baseUrl),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStore.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final storedRefresh = _tokenStore.refreshToken;
    if (storedRefresh == null || storedRefresh.isEmpty) {
      await _onLogout();
      handler.next(err);
      return;
    }

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': storedRefresh},
        options: Options(contentType: Headers.jsonContentType),
      );

      final data = response.data;
      if (data == null) throw Exception('Empty refresh response');

      final newAccess = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String?;

      if (newAccess == null ||
          newAccess.isEmpty ||
          newRefresh == null ||
          newRefresh.isEmpty) {
        throw Exception('Invalid refresh response');
      }

      _tokenStore.accessToken = newAccess;
      _tokenStore.refreshToken = newRefresh;
      await _onTokensRefreshed(newAccess, newRefresh);

      // Retry the original request with the new access token.
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccess';
      final retried = await Dio().fetch<dynamic>(opts);
      handler.resolve(retried);
    } catch (_) {
      await _onLogout();
      handler.next(err);
    }
  }
}
