import 'package:dio/dio.dart';
import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/features/auth/domain/errors/auth_exception.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/auth_api.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';

/// Auth API implementation using Dio. Throws [AuthException] on failure.
class AuthRemote implements AuthApi {
  AuthRemote([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<AuthSession> signIn(SignInRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/signin',
      data: request.toJson(),
      options: Options(
        contentType: Headers.jsonContentType,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    if (response.data == null) {
      throw AuthException('Invalid server response.');
    }

    final data = response.data!;
    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = data['message'] as String? ?? 'Login failed';
      throw AuthException(message);
    }

    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;

    if (accessToken == null || accessToken.isEmpty || refreshToken == null || refreshToken.isEmpty) {
      throw AuthException('Invalid server response.');
    }

    return AuthSession(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
