import '../models/kitchen_pending_order.dart';

/// Contract for fetching kitchen pending orders for a venue.
abstract class KitchenPendingApi {
  /// Fetches pending orders for [venueId].
  /// Returns list ordered as returned by API; caller should sort by
  /// [KitchenPendingOrder.targetTime] ascending for oldest-first.
  Future<List<KitchenPendingOrder>> getPendingOrders(String venueId);
}
