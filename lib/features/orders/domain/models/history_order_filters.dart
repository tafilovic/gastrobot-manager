import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';

/// Filter state for history orders (waiter). Used by [FilterHistoryOrdersScreen].
class HistoryOrderFilters {
  HistoryOrderFilters({
    DateTime? dateFrom,
    DateTime? dateTo,
    this.orderContentTypes = const {},
    this.tableIds = const {},
    this.billMin = 0,
    this.billMax = 200000,
  }) : dateFrom = dateFrom != null
           ? CalendarDayBounds.startOfDay(dateFrom)
           : null,
       dateTo = dateTo != null ? CalendarDayBounds.endOfDay(dateTo) : null;

  final DateTime? dateFrom;
  final DateTime? dateTo;

  /// 'food' and/or 'drink': empty = no filter; otherwise order must match selected types.
  final Set<String> orderContentTypes;
  /// Selected venue table ids from GET /venues/:venueId/tables (same matching rules as active order filters).
  final Set<String> tableIds;
  final double billMin;
  final double billMax;

  static const String orderContentFood = 'food';
  static const String orderContentDrink = 'drink';

  HistoryOrderFilters copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    Set<String>? orderContentTypes,
    Set<String>? tableIds,
    double? billMin,
    double? billMax,
  }) {
    return HistoryOrderFilters(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      orderContentTypes: orderContentTypes ?? this.orderContentTypes,
      tableIds: tableIds ?? this.tableIds,
      billMin: billMin ?? this.billMin,
      billMax: billMax ?? this.billMax,
    );
  }

  bool get isEmpty =>
      dateFrom == null &&
      dateTo == null &&
      orderContentTypes.isEmpty &&
      tableIds.isEmpty &&
      billMin <= 0 &&
      billMax >= 200000;
}
