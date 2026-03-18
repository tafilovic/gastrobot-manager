import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';

/// Contract for fetching pending reservation requests.
/// Waiter: GET …/waiter/reservations/pending
/// Kitchen: …/kitchen/pending?source=reservation
/// Bar: …/bar/pending?source=reservation
abstract class ReservationsApi {
  Future<List<PendingOrder>> getRequests(String venueId, ProfileType profileType);
}
