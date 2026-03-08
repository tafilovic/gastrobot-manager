import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/orders/domain/errors/orders_exception.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/pending_orders_api.dart';

import '../../../core/api/api_config.dart';

/// Fetches pending orders by role: kitchen/pending or bar/pending.
/// Waiter has no endpoint and returns empty list.
class PendingOrdersRemote implements PendingOrdersApi {
  PendingOrdersRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<List<PendingOrder>> getPendingOrders(
    String venueId,
    ProfileType profileType,
  ) async {
    final String path;
    final Map<String, dynamic>? queryParams;
    if (profileType == ProfileType.waiter) {
      path = '/venues/$venueId/waiter/pending-orders';
      queryParams = null;
    } else if (profileType == ProfileType.bar) {
      path = '/venues/$venueId/bar/pending';
      queryParams = {'source': 'walk_in'};
    } else {
      path = '/venues/$venueId/kitchen/pending';
      queryParams = {'source': 'walk_in'};
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: queryParams,
        options: Options(
          validateStatus: (int? status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        throw OrdersException('Invalid response');
      }

      if (response.statusCode != 200) {
        final msg = (response.data is Map)
            ? (response.data as Map)['message']?.toString()
            : null;
        throw OrdersException(msg ?? 'Failed to load orders');
      }

      final raw = response.data as dynamic;
      final list = raw is List<dynamic>
          ? raw
          : <dynamic>[];
      return list
          .map((e) => PendingOrder.fromJson(
              e is Map ? Map<String, dynamic>.from(e as Map) : <String, dynamic>{}))
          .where((o) => o.orderId.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw OrdersException(message ?? e.message ?? 'Network error');
    }
  }
}
