import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/queue_item.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/queue_order.dart';
import 'package:gastrobotmanager/features/ready_items/domain/errors/ready_items_exception.dart';
import 'package:gastrobotmanager/features/ready_items/domain/repositories/ready_items_api.dart';

/// Fetches waiter ready-to-serve items via GET .../venues/:venueId/waiter/ready-items
/// and marks as delivered via PATCH .../venues/:venueId/waiter/deliver.
/// API shape: orderId, orderNumber, tableName, note, items[] with orderItemId,
/// productName, quantity, type, additionalInfo, addons, markedReadyAt.
class ReadyItemsRemote implements ReadyItemsApi {
  ReadyItemsRemote([Dio? dio])
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  static String _readyItemsUrl(String venueId) =>
      '/venues/$venueId/waiter/ready-items';

  static String _deliverUrl(String venueId) =>
      '/venues/$venueId/waiter/deliver';

  /// Maps waiter ready-items API response to [QueueOrder].
  static QueueOrder _orderFromWaiterJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'] ?? const [];
    final itemsList = itemsRaw is List<dynamic> ? itemsRaw : <dynamic>[];
    String latestMarkedReady = '';
    final items = <QueueItem>[];
    for (final e in itemsList) {
      if (e == null || e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final markedReady = m['markedReadyAt']?.toString();
      if (markedReady != null && markedReady.isNotEmpty) {
        if (latestMarkedReady.isEmpty ||
            markedReady.compareTo(latestMarkedReady) > 0) {
          latestMarkedReady = markedReady;
        }
      }
      final qty = m['quantity'];
      final quantity = qty is int
          ? qty
          : (int.tryParse(qty?.toString() ?? '1') ?? 1);
      items.add(
        QueueItem(
          id: m['orderItemId']?.toString() ?? '',
          name: m['productName']?.toString() ?? '',
          quantity: quantity,
          notes: m['additionalInfo']?.toString() ?? '',
          status: 'ready',
          addons: m['addons'] is List<dynamic>
              ? m['addons'] as List<dynamic>
              : const [],
          type: m['type']?.toString(),
        ),
      );
    }
    final tableName = json['tableName']?.toString();
    final tableNumber =
        (tableName == null || tableName.isEmpty || tableName == 'N/A')
        ? '0'
        : tableName;
    return QueueOrder(
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      tableNumber: tableNumber,
      note: json['note'] as String?,
      type: 'immediate',
      targetTime: latestMarkedReady.isNotEmpty
          ? latestMarkedReady
          : DateTime.now().toUtc().toIso8601String(),
      isFuture: false,
      items: items,
    );
  }

  @override
  Future<List<QueueOrder>> getReadyItems(String venueId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        _readyItemsUrl(venueId),
        options: Options(
          validateStatus: (int? status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        throw const ReadyItemsException('Invalid response');
      }

      if (response.statusCode != 200) {
        final msg = (response.data is Map)
            ? (response.data as Map)['message']?.toString()
            : null;
        throw ReadyItemsException(msg ?? 'Failed to load ready items');
      }

      final raw = response.data as dynamic;
      final List<dynamic> list = raw is List<dynamic>
          ? raw
          : (raw is Map<String, dynamic> && raw['data'] is List<dynamic>)
          ? raw['data'] as List<dynamic>
          : <dynamic>[];
      final orders = <QueueOrder>[];
      for (final e in list) {
        if (e == null || e is! Map) continue;
        try {
          final order = _orderFromWaiterJson(Map<String, dynamic>.from(e));
          if (order.orderId.isNotEmpty && order.items.isNotEmpty) {
            orders.add(order);
          }
        } catch (_) {
          // Skip malformed items
        }
      }
      return orders;
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ReadyItemsException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<bool> markAsServed(String venueId, List<String> orderItemIds) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        _deliverUrl(venueId),
        data: {'orderItemIds': orderItemIds},
        options: Options(
          validateStatus: (int? status) => status != null && status < 400,
        ),
      );

      if (response.data == null) return false;
      return response.data!['success'] as bool? ?? false;
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ReadyItemsException(message ?? e.message ?? 'Network error');
    }
  }
}
