import 'package:dio/dio.dart';
import 'package:gastrobotmanager/features/orders/domain/errors/kitchen_orders_exception.dart';
import 'package:gastrobotmanager/features/orders/domain/models/kitchen_pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/kitchen_pending_api.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';

/// Fetches kitchen pending orders via GET /venues/{venueId}/kitchen/pending?source=walk_in.
class KitchenPendingRemote implements KitchenPendingApi {
  KitchenPendingRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<List<KitchenPendingOrder>> getPendingOrders(String venueId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/venues/$venueId/kitchen/pending',
        queryParameters: {'source': 'walk_in'},
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        throw KitchenOrdersException('Invalid response');
      }

      if (response.statusCode != 200) {
        final msg = (response.data is Map)
            ? (response.data as Map)['message']?.toString()
            : null;
        throw KitchenOrdersException(msg ?? 'Failed to load orders');
      }

      return (response.data!)
          .map((e) => KitchenPendingOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw KitchenOrdersException(message ?? e.message ?? 'Network error');
    }
  }
}
