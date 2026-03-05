import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gastrobotmanager/features/profile/domain/errors/profile_exception.dart';
import 'package:gastrobotmanager/features/profile/domain/repositories/profile_api.dart';

import '../../../core/api/api_config.dart';

/// Profile API implementation. PATCH /users/profile-image with multipart.
class ProfileRemote implements ProfileApi {
  ProfileRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

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
}
