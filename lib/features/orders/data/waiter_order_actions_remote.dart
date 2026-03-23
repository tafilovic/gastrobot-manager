import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/orders/domain/errors/orders_exception.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/waiter_order_actions_api.dart';

class WaiterOrderActionsRemote implements WaiterOrderActionsApi {
  WaiterOrderActionsRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<void> markOrderAsPaid(String venueId, String orderId) async {
    final path = '/venues/$venueId/waiter/orders/$orderId/pay';
    try {
      final response = await _dio.patch<dynamic>(
        path,
        options: Options(
          validateStatus: (int? status) => status != null && status < 400,
        ),
      );
      final code = response.statusCode;
      if (code != null && code >= 200 && code < 300) {
        return;
      }
      final data = response.data;
      final msg = data is Map ? data['message']?.toString() : null;
      throw OrdersException(msg ?? 'Failed to mark order as paid');
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw OrdersException(message ?? e.message ?? 'Network error');
    }
  }

  static List<dynamic> _listFromResponse(dynamic data) {
    if (data == null) return [];
    if (data is List<dynamic>) return data;
    if (data is Map) {
      for (final key in ['orders', 'data', 'items', 'paidOrders']) {
        final v = data[key];
        if (v is List<dynamic>) return v;
        if (v is List) return List<dynamic>.from(v);
      }
    }
    return [];
  }

  @override
  Future<List<PendingOrder>> getPaidOrders(String venueId) async {
    final path = '/venues/$venueId/waiter/paid-orders';
    try {
      final response = await _dio.get<dynamic>(
        path,
        options: Options(
          validateStatus: (int? status) => status != null && status < 400,
        ),
      );
      if (response.statusCode != 200) {
        final data = response.data;
        final msg = data is Map ? data['message']?.toString() : null;
        throw OrdersException(msg ?? 'Failed to load paid orders');
      }
      final raw = _listFromResponse(response.data);
      return raw
          .map((e) => PendingOrder.fromJson(
                e is Map
                    ? Map<String, dynamic>.from(e)
                    : <String, dynamic>{},
              ))
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

