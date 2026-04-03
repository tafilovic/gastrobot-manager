import 'package:dio/dio.dart';
import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/features/auth/domain/errors/auth_exception.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/auth_api.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/register_request.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';

/// Auth API implementation using Dio. Throws [AuthException] on failure.
class AuthRemote implements AuthApi {
  AuthRemote([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<AuthSession> signIn(SignInRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/signin',
        data: request.toJson(),
        options: Options(
          contentType: Headers.jsonContentType,
          validateStatus: (status) => status != null,
        ),
      );

      final data = response.data;
      if (data == null) {
        throw AuthException('Invalid server response.');
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = data['message'] as String? ?? 'Login failed';
        throw AuthException(message);
      }

      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;

      if (accessToken == null ||
          accessToken.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        throw AuthException('Invalid server response.');
      }

      return AuthSession(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } on AuthException {
      rethrow;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String?;
        if (message != null && message.isNotEmpty) {
          throw AuthException(message);
        }
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw AuthException('Connection timed out. Check your network.');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw AuthException('Cannot reach server. Check your connection.');
      }
      throw AuthException(e.message ?? 'Login failed');
    }
  }

  @override
  Future<void> register(RegisterRequest request) async {
    final headers = <String, dynamic>{};
    if (ApiConfig.registerBearer.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${ApiConfig.registerBearer}';
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/users/register',
      data: request.toJson(),
      options: Options(
        contentType: Headers.jsonContentType,
        headers: headers.isEmpty ? null : headers,
        validateStatus: (status) => status != null,
      ),
    );

    if (response.statusCode == 201) {
      return;
    }

    final data = response.data;
    String message = 'Registration failed';
    if (data != null) {
      final m = data['message'];
      if (m != null) {
        message = m.toString();
      }
    }
    throw AuthException(message);
  }
}
