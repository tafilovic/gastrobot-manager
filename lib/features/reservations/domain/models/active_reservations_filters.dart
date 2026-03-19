/// Filter state for active (accepted) reservations.
/// Used by [ActiveReservationsFilterScreen].
/// Matches UI design: date, people count, region, reservation content, table numbers.
class ActiveReservationsFilters {
  const ActiveReservationsFilters({
    this.dateFrom,
    this.dateTo,
    this.peopleCounts = const {},
    this.regions = const {},
    this.reservationContents = const {},
    this.tableNumbers = const {},
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final Set<int> peopleCounts;
  final Set<String> regions;
  final Set<String> reservationContents;
  final Set<String> tableNumbers;

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
    Set<String>? tableNumbers,
  }) {
    return ActiveReservationsFilters(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      peopleCounts: peopleCounts ?? this.peopleCounts,
      regions: regions ?? this.regions,
      reservationContents: reservationContents ?? this.reservationContents,
      tableNumbers: tableNumbers ?? this.tableNumbers,
    );
  }

  bool get isEmpty =>
      dateFrom == null &&
      dateTo == null &&
      peopleCounts.isEmpty &&
      regions.isEmpty &&
      reservationContents.isEmpty &&
      tableNumbers.isEmpty;
}
