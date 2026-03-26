import 'dart:io';

import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/features/profile/domain/errors/profile_exception.dart';
import 'package:gastrobotmanager/features/profile/domain/repositories/profile_api.dart';

/// Profile API implementation. GET /v1/users/me, DELETE /v1/users/me, PATCH /users/profile-image.
class ProfileRemote implements ProfileApi {
  ProfileRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<User?> getMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v1/users/me',
        options: Options(validateStatus: (s) => s != null && s < 400),
      );
      final data = response.data;
      if (data == null || response.statusCode != 200) return null;
      final map = data['user'] is Map
          ? Map<String, dynamic>.from(data['user'] as Map)
          : Map<String, dynamic>.from(data);
      return User.fromJson(map);
    } on DioException catch (_) {
      return null;
    }
  }

  @override
  Future<String?> updateProfileImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
      });

      final response = await _dio.patch<Map<String, dynamic>>(
        '/users/profile-image',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final msg = response.data is Map
            ? (response.data as Map)['message'] as String?
            : null;
        throw ProfileException(msg ?? 'Upload failed');
      }

      final data = response.data;
      if (data == null) return null;

      return data['profileImageUrl'] as String? ??
          (data['user'] is Map
              ? (data['user'] as Map<String, dynamic>)['profileImageUrl']
                  as String?
              : null);
    } on DioException catch (e) {
      throw ProfileException(e.response?.data is Map
          ? (e.response!.data as Map)['message'] as String? ??
              e.message ??
              'Upload failed'
          : e.message ?? 'Upload failed');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final response = await _dio.delete<void>('/v1/users/me');
      final code = response.statusCode;
      if (code == null || code < 200 || code >= 300) {
        throw ProfileException('Account deletion failed');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = data is Map ? data['message'] as String? : null;
      throw ProfileException(msg ?? e.message ?? 'Account deletion failed');
    }
  }
}
