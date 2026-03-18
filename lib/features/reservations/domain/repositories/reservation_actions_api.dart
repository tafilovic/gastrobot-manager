/// Actions on a reservation (waiter).
abstract class ReservationActionsApi {
  /// PUT /v1/venues/:venueId/reservations/:reservationId/reject
  Future<void> rejectReservation({
    required String venueId,
    required String reservationId,
    required String reason,
  });
}

