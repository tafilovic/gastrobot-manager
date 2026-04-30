import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/models/paginated_result.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';

/// Contract for fetching reservation requests.
/// Waiter: GET …/v1/venues/:venueId/reservations?status=pending → [PendingReservation]
/// Kitchen: …/kitchen/pending?source=reservation
/// Bar: …/bar/pending?source=reservation
abstract class ReservationsApi {
  /// Waiter pending reservations (full reservation entities).
  Future<PaginatedResult<PendingReservation>> getWaiterPendingReservations({
    required String venueId,
    required int page,
    required int limit,
  });

  /// Kitchen/bar pending rows that represent reservations ([PendingOrder] shape).
  Future<List<PendingOrder>> getKitchenBarReservationRequests(
    String venueId,
    ProfileType profileType,
  );
}
