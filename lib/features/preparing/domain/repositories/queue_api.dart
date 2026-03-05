import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/queue_order.dart';

/// Contract for fetching queue (preparing) orders and marking items ready.
/// Kitchen: GET .../kitchen/queue, PATCH .../kitchen/ready
/// Bar: GET .../bar/queue, PATCH .../bar/ready (via proxy when used).
abstract class QueueApi {
  Future<List<QueueOrder>> getQueue(String venueId, ProfileType profileType);

  /// Marks order items as ready. Returns [true] if the server reported success.
  Future<bool> markAsReady(
    String venueId,
    List<String> orderItemIds,
    ProfileType profileType,
  );
}
