import 'package:gastrobotmanager/features/reservations/utils/trim_reservation_number.dart';

/// Filter state for pending (request) reservations.
/// Matches API: reservationNumber, regionId (no date range).
class PendingReservationsFilters {
  PendingReservationsFilters({
    this.reservationNumber,
    this.regionId,
  });

  final String? reservationNumber;

  /// Venue region id; null means all regions.
  final String? regionId;

  String? get trimmedReservationNumber =>
      trimReservationNumber(reservationNumber);

  PendingReservationsFilters copyWith({
    String? reservationNumber,
    String? regionId,
    bool clearReservationNumber = false,
    bool clearRegionId = false,
  }) {
    return PendingReservationsFilters(
      reservationNumber: clearReservationNumber
          ? null
          : (reservationNumber ?? this.reservationNumber),
      regionId: clearRegionId ? null : (regionId ?? this.regionId),
    );
  }

  bool get isEmpty => trimmedReservationNumber == null && regionId == null;
}
