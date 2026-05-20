import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';

/// Filter state for confirmed (processed) reservations.
/// Matches API: reservationNumber, regionId, from/to date range.
class ConfirmedReservationsFilters {
  ConfirmedReservationsFilters({
    this.reservationNumber,
    this.regionId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) : dateFrom = dateFrom != null
           ? CalendarDayBounds.startOfDay(dateFrom)
           : null,
       dateTo = dateTo != null ? CalendarDayBounds.endOfDay(dateTo) : null;

  /// Search by reservation number (without leading `#`).
  final String? reservationNumber;

  /// Venue region id; null means all regions.
  final String? regionId;

  /// Custom range start; null with [dateTo] uses start of [dateTo] day.
  final DateTime? dateFrom;

  /// Custom range end; null with [dateFrom] uses end of [dateFrom] day.
  final DateTime? dateTo;

  /// Default list range when no custom dates: today − 1 month → +4 months.
  static ({DateTime from, DateTime to}) defaultApiDateRange([DateTime? now]) {
    final today = now ?? DateTime.now();
    final from = CalendarDayBounds.startOfDay(
      DateTime(today.year, today.month - 1, today.day),
    );
    final to = CalendarDayBounds.endOfDay(
      DateTime(from.year, from.month + 4, from.day),
    );
    return (from: from, to: to);
  }

  bool get hasCustomDateRange => dateFrom != null || dateTo != null;

  /// ISO bounds sent as `from` / `to` query params.
  ({DateTime from, DateTime to}) get apiDateRange {
    if (!hasCustomDateRange) return defaultApiDateRange();

    final from = dateFrom != null
        ? CalendarDayBounds.startOfDay(dateFrom!)
        : CalendarDayBounds.startOfDay(dateTo!);
    final to = dateTo != null
        ? CalendarDayBounds.endOfDay(dateTo!)
        : CalendarDayBounds.endOfDay(dateFrom!);

    if (from.isAfter(to)) {
      return (
        from: CalendarDayBounds.startOfDay(to),
        to: CalendarDayBounds.endOfDay(from),
      );
    }
    return (from: from, to: to);
  }

  String? get trimmedReservationNumber {
    final raw = reservationNumber?.trim();
    if (raw == null || raw.isEmpty) return null;
    return raw.startsWith('#') ? raw.substring(1).trim() : raw;
  }

  ConfirmedReservationsFilters copyWith({
    String? reservationNumber,
    String? regionId,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearReservationNumber = false,
    bool clearRegionId = false,
    bool clearDateRange = false,
  }) {
    return ConfirmedReservationsFilters(
      reservationNumber: clearReservationNumber
          ? null
          : (reservationNumber ?? this.reservationNumber),
      regionId: clearRegionId ? null : (regionId ?? this.regionId),
      dateFrom: clearDateRange ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateRange ? null : (dateTo ?? this.dateTo),
    );
  }

  bool get isEmpty =>
      (trimmedReservationNumber == null) &&
      regionId == null &&
      !hasCustomDateRange;
}
