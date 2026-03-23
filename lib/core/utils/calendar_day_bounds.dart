/// Local calendar-day bounds for filter date ranges.
///
/// [startOfDay] → 00:00:00.000; [endOfDay] → 23:59:59.999 for the same calendar day.
/// Use everywhere filters send or compare by date (API ISO strings, client-side day checks).
final class CalendarDayBounds {
  CalendarDayBounds._();

  static DateTime startOfDay(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  static DateTime endOfDay(DateTime d) {
    return DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
  }
}
