import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';

/// Contract for fetching pending reservation requests.
/// Waiter: GET …/waiter/reservations/pending → [PendingReservation]
/// Kitchen: …/kitchen/pending?source=reservation
/// Bar: …/bar/pending?source=reservation
abstract class ReservationsApi {
  /// Waiter pending reservations (full reservation entities).
  Future<List<PendingReservation>> getWaiterPendingReservations(String venueId);

  /// Kitchen/bar pending rows that represent reservations ([PendingOrder] shape).
  Future<List<PendingOrder>> getKitchenBarReservationRequests(
    String venueId,
    ProfileType profileType,
  );
}
