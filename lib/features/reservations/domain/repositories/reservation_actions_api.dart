/// Actions on a reservation (waiter).
abstract class ReservationActionsApi {
  /// PUT /v1/venues/:venueId/reservations/:reservationId/reject
  Future<void> rejectReservation({
    required String venueId,
    required String reservationId,
    required String reason,
  });

  /// PUT /reservation/:reservationId/confirm
  /// Body: { tableIds: [String], note? }
  Future<void> acceptReservation({
    required String venueId,
    required String reservationId,
    required List<String> tableIds,
    String? note,
  });
}

