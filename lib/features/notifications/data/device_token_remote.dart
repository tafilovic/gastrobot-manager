import 'package:dio/dio.dart';

class DeviceTokenRemote {
  DeviceTokenRemote(this._dio);

  final Dio _dio;

  Future<void> registerToken({
    required String token,
    required String platform,
  }) async {
    await _dio.post<void>(
      '/notifications/register-token',
      data: {'token': token, 'platform': platform},
      options: Options(contentType: Headers.jsonContentType),
    );
  }
}
