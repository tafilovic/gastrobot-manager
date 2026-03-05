import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/preparing/domain/errors/preparing_exception.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/kitchen_queue_order.dart';
import 'package:gastrobotmanager/features/preparing/domain/repositories/kitchen_queue_api.dart';

/// Fetches kitchen queue (preparing) via GET /venues/{venueId}/kitchen/queue?prepStatus=ready.
class KitchenQueueRemote implements KitchenQueueApi {
  KitchenQueueRemote([Dio? dio])
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<List<KitchenQueueOrder>> getQueue(String venueId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/venues/$venueId/kitchen/queue',
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
          .map((e) => KitchenQueueOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw PreparingException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<bool> markAsReady(String venueId, List<String> orderItemIds) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/venues/$venueId/kitchen/ready',
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
