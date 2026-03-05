import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/preparing/domain/errors/preparing_exception.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/queue_order.dart';
import 'package:gastrobotmanager/features/preparing/domain/repositories/queue_api.dart';

/// Fetches queue (preparing) by role: kitchen/queue or bar/queue (bar via proxy).
/// Uses [dio] for both; bar requests use full URL with [ApiConfig.proxyBaseUrl] so auth is sent.
class QueueRemote implements QueueApi {
  QueueRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  String _queueUrl(String venueId, ProfileType profileType) {
    if (profileType == ProfileType.bar) {
      return '${ApiConfig.baseUrl}/venues/$venueId/bar/queue';
    }
    return '/venues/$venueId/kitchen/queue';
  }

  String _readyUrl(String venueId, ProfileType profileType) {
    if (profileType == ProfileType.bar) {
      return '${ApiConfig.baseUrl}/venues/$venueId/bar/ready';
    }
    return '/venues/$venueId/kitchen/ready';
  }

  @override
  Future<List<QueueOrder>> getQueue(
    String venueId,
    ProfileType profileType,
  ) async {
    if (profileType == ProfileType.waiter) {
      return [];
    }

    final url = _queueUrl(venueId, profileType);

    try {
      final response = await _dio.get<List<dynamic>>(
        url,
        queryParameters: {'prepStatus': 'ready'},
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        throw const PreparingException('Invalid response');
      }

      if (response.statusCode != 200) {
        final msg = (response.data is Map)
            ? (response.data as Map)['message']?.toString()
            : null;
        throw PreparingException(msg ?? 'Failed to load queue');
      }

      return (response.data!)
          .map((e) => QueueOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw PreparingException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<bool> markAsReady(
    String venueId,
    List<String> orderItemIds,
    ProfileType profileType,
  ) async {
    if (profileType == ProfileType.waiter) return false;

    final url = _readyUrl(venueId, profileType);

    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        url,
        data: {'orderItemIds': orderItemIds},
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null) return false;
      return response.data!['success'] as bool? ?? false;
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw PreparingException(message ?? e.message ?? 'Network error');
    }
  }
}
