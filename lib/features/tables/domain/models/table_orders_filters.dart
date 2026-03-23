import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';

/// Filter state for table orders (GET /v1/tables/:id/orders). Used by
/// [FilterTableOrdersScreen] and [TableOverviewScreen].
class TableOrdersFilters {
  TableOrdersFilters({
    required DateTime dateFrom,
    required DateTime dateTo,
    this.orderType,
    this.orderStatus,
    this.billMin = 0,
    this.billMax = 200000,
  }) : dateFrom = CalendarDayBounds.startOfDay(dateFrom),
       dateTo = CalendarDayBounds.endOfDay(dateTo);

  /// Inclusive lower bound: always local **00:00:00.000** for the chosen calendar day.
  final DateTime dateFrom;

  /// Inclusive upper bound: always local **23:59:59.999** for the chosen calendar day.
  final DateTime dateTo;

  /// API `type`: `food` or `drink`; omit when null.
  final String? orderType;

  /// API `status`; omit when null.
  final String? orderStatus;

  final double billMin;
  final double billMax;

  static const String orderTypeFood = 'food';
  static const String orderTypeDrink = 'drink';

  static const List<String> orderStatusValues = <String>[
    'awaiting_confirmation',
    'pending',
    'confirmed',
    'rejected',
    'expired',
    'paid',
  ];

  /// Default range: yesterday 00:00:00.000 – today 23:59:59.999 (local),
  /// [orderType] / [orderStatus] null, [billMin] 0, [billMax] 200_000.
  factory TableOrdersFilters.defaults({DateTime? clock}) {
    final n = clock ?? DateTime.now();
    final todayStart = DateTime(n.year, n.month, n.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    return TableOrdersFilters(
      dateFrom: yesterdayStart,
      dateTo: todayStart,
      orderType: null,
      orderStatus: null,
      billMin: 0,
      billMax: 200000,
    );
  }

  int get apiMinPrice {
    if (billMin <= 0) {
      return 0;
    }
    return billMin.ceil();
  }

  int get apiMaxPrice {
    final maxRounded = billMax.ceil();
    final minP = apiMinPrice;
    return maxRounded < minP ? minP : maxRounded;
  }
}
