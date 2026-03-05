import '../models/kitchen_queue_order.dart';

/// Contract for fetching kitchen queue (preparing) orders and marking items ready.
/// GET .../venues/{venueId}/kitchen/queue?prepStatus=ready
/// POST .../venues/{venueId}/kitchen/ready
abstract class KitchenQueueApi {
  Future<List<KitchenQueueOrder>> getQueue(
    String venueId,
    String accessToken,
  );

  /// Marks order items as ready. Returns [true] if the server reported success.
  Future<bool> markAsReady(
    String venueId,
    List<String> orderItemIds,
    String accessToken,
  );
}
