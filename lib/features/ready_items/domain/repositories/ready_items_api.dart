import 'package:gastrobotmanager/features/preparing/domain/models/queue_order.dart';

/// Contract for waiter ready-to-serve items: fetch list and mark as served.
/// GET .../venues/:venueId/waiter/ready-items, PATCH .../venues/:venueId/waiter/served
abstract class ReadyItemsApi {
  Future<List<QueueOrder>> getReadyItems(String venueId);

  /// Marks order items as served. Returns [true] if the server reported success.
  Future<bool> markAsServed(String venueId, List<String> orderItemIds);
}
