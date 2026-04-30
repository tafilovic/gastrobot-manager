import 'package:gastrobotmanager/core/models/paginated_result.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';

/// Contract for fetching confirmed reservations (waiter view).
abstract class ConfirmedReservationsApi {
  /// GET /v1/venues/:venueId/reservations?status=confirmed
  Future<PaginatedResult<ConfirmedReservation>> getConfirmed({
    required String venueId,
    required int page,
    required int limit,
  });
}
