import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';

/// Filter state for active (accepted) reservations.
/// Used by [ActiveReservationsFilterScreen].
/// Matches UI design: date, people count, region, reservation content, table ids.
class ActiveReservationsFilters {
  ActiveReservationsFilters({
    DateTime? dateFrom,
    DateTime? dateTo,
    this.peopleCounts = const {},
    this.regions = const {},
    this.reservationContents = const {},
    this.tableIds = const {},
  }) : dateFrom = dateFrom != null
           ? CalendarDayBounds.startOfDay(dateFrom)
           : null,
       dateTo = dateTo != null ? CalendarDayBounds.endOfDay(dateTo) : null;

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final Set<int> peopleCounts;
  final Set<String> regions;
  final Set<String> reservationContents;
  final Set<String> tableIds;

  /// Region: indoors (Unutrašnjost).
  static const String regionIndoors = 'indoors';

  /// Region: garden (Bašta).
  static const String regionGarden = 'garden';

  /// Reservation content: drink (Piće).
  static const String contentDrink = 'drink';

  /// Reservation content: food (Hrana).
  static const String contentFood = 'food';

  ActiveReservationsFilters copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    Set<int>? peopleCounts,
    Set<String>? regions,
    Set<String>? reservationContents,
    Set<String>? tableIds,
  }) {
    return ActiveReservationsFilters(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      peopleCounts: peopleCounts ?? this.peopleCounts,
      regions: regions ?? this.regions,
      reservationContents: reservationContents ?? this.reservationContents,
      tableIds: tableIds ?? this.tableIds,
    );
  }

  bool get isEmpty =>
      dateFrom == null &&
      dateTo == null &&
      peopleCounts.isEmpty &&
      regions.isEmpty &&
      reservationContents.isEmpty &&
      tableIds.isEmpty;
}
