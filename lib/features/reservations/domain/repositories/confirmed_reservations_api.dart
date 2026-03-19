import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';

/// Contract for fetching confirmed reservations (waiter view).
abstract class ConfirmedReservationsApi {
  /// GET /venues/:venueId/waiter/reservations/confirmed
  Future<List<ConfirmedReservation>> getConfirmed(String venueId);
}
