import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';

/// Waiter-only order endpoints (pay, paid list, etc.).
abstract class WaiterOrderActionsApi {
  /// PATCH …/venues/:venueId/waiter/orders/:orderId/pay
  Future<void> markOrderAsPaid(String venueId, String orderId);

  /// GET …/venues/:venueId/waiter/paid-orders
  Future<List<PendingOrder>> getPaidOrders(String venueId);
}

