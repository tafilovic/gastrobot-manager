/// Filter state for active orders (waiter). Used by [FilterActiveOrdersScreen].
class ActiveOrderFilters {
  const ActiveOrderFilters({
    this.tableNumbers = const {},
    this.foodStatuses = const {},
    this.drinkStatuses = const {},
    this.billMin = 0,
    this.billMax = 200000,
  });

  final Set<String> tableNumbers;
  final Set<String> foodStatuses;
  final Set<String> drinkStatuses;
  final double billMin;
  final double billMax;

  static const String statusPending = 'pending';
  static const String statusInPreparation = 'in_preparation';
  static const String statusServed = 'served';
  static const String statusRejected = 'rejected';

  ActiveOrderFilters copyWith({
    Set<String>? tableNumbers,
    Set<String>? foodStatuses,
    Set<String>? drinkStatuses,
    double? billMin,
    double? billMax,
  }) {
    return ActiveOrderFilters(
      tableNumbers: tableNumbers ?? this.tableNumbers,
      foodStatuses: foodStatuses ?? this.foodStatuses,
      drinkStatuses: drinkStatuses ?? this.drinkStatuses,
      billMin: billMin ?? this.billMin,
      billMax: billMax ?? this.billMax,
    );
  }

  bool get isEmpty =>
      tableNumbers.isEmpty &&
      foodStatuses.isEmpty &&
      drinkStatuses.isEmpty &&
      billMin <= 0 &&
      billMax >= 200000;
}
