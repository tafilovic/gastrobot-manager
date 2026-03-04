import 'package:dio/dio.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/order_items_api.dart';

import '../../../core/api/api_config.dart';

/// Accept/reject order items via PATCH endpoints.
class OrderItemsRemote implements OrderItemsApi {
  OrderItemsRemote([Dio? dio])
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<void> acceptOrderItem(
    String venueId,
    String orderId,
    String itemId,
    String accessToken,
  ) async {
    await _dio.patch<void>(
      '/venues/$venueId/orders/$orderId/order-items/$itemId/accept',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
        validateStatus: (status) => status != null && status < 400,
      ),
    );
  }

  @override
  Future<void> rejectOrderItem(
    String venueId,
    String orderId,
    String itemId,
    String accessToken, {
    String? rejectionReason,
  }) async {
    // Body structure prepared for future use; not sent for now.
    // When needed: data: rejectionReason != null ? {'rejectionReason': rejectionReason} : null,
    await _dio.patch<void>(
      '/venues/$venueId/orders/$orderId/order-items/$itemId/reject',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
        validateStatus: (status) => status != null && status < 400,
      ),
    );
  }
}
