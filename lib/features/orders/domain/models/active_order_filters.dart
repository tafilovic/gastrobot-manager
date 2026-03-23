/// Filter state for active orders (waiter). Used by [FilterActiveOrdersScreen].
class ActiveOrderFilters {
  const ActiveOrderFilters({
    this.tableIds = const {},
    this.foodStatuses = const {},
    this.drinkStatuses = const {},
    this.billMin = 0,
    this.billMax = 200000,
  });

  /// Selected venue table ids from GET /venues/:venueId/tables (each row’s `id` field).
  /// Order filtering compares to each order’s parsed table id (trim + case-insensitive);
  /// if the order payload has no table id, a name fallback applies only when unambiguous.
  final Set<String> tableIds;
  final Set<String> foodStatuses;
  final Set<String> drinkStatuses;
  final double billMin;
  final double billMax;

  static const String statusPending = 'pending';
  static const String statusInPreparation = 'in_preparation';
  static const String statusServed = 'served';
  static const String statusRejected = 'rejected';

  ActiveOrderFilters copyWith({
    Set<String>? tableIds,
    Set<String>? foodStatuses,
    Set<String>? drinkStatuses,
    double? billMin,
    double? billMax,
  }) {
    return ActiveOrderFilters(
      tableIds: tableIds ?? this.tableIds,
      foodStatuses: foodStatuses ?? this.foodStatuses,
      drinkStatuses: drinkStatuses ?? this.drinkStatuses,
      billMin: billMin ?? this.billMin,
      billMax: billMax ?? this.billMax,
    );
  }

  bool get isEmpty =>
      tableIds.isEmpty &&
      foodStatuses.isEmpty &&
      drinkStatuses.isEmpty &&
      billMin <= 0 &&
      billMax >= 200000;
}
