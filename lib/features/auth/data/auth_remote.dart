import 'package:dio/dio.dart';

import '../../../core/api/api_config.dart';
import '../../../core/models/user.dart';
import '../models/auth_session.dart';
import '../models/sign_in_request.dart';

/// Auth API client (signin). Uses [ApiConfig.baseUrl].
class AuthRemote {
  AuthRemote([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  Future<AuthSession> signIn(SignInRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/signin',
      data: request.toJson(),
      options: Options(
        contentType: Headers.jsonContentType,
        validateStatus: (status) => status != null && status! < 400,
      ),
    );

    if (response.data == null) {
      throw AuthApiException('No data in response');
    }

    final data = response.data!;
    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = data['message'] as String? ?? 'Login failed';
      throw AuthApiException(message);
    }

    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;

    if (accessToken == null || accessToken.isEmpty || refreshToken == null || refreshToken.isEmpty) {
      throw AuthApiException('Missing tokens in response');
    }

    return AuthSession(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

class AuthApiException implements Exception {
  AuthApiException(this.message);
  final String message;
  @override
  String toString() => message;
}
