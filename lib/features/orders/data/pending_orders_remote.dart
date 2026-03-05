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
    if (profileType == ProfileType.waiter) {
      return [];
    }

    final path = profileType == ProfileType.bar
        ? '/venues/$venueId/bar/pending'
        : '/venues/$venueId/kitchen/pending';

    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: {'source': 'walk_in'},
        options: Options(
          validateStatus: (status) => status != null && status < 400,
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

      return (response.data!)
          .map((e) => PendingOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw OrdersException(message ?? e.message ?? 'Network error');
    }
  }
}
