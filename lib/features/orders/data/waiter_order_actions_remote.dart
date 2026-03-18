import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/orders/domain/errors/orders_exception.dart';
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
}
