import 'package:intl/intl.dart';

import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservations_filters.dart';

/// Formats a calendar day as `dd.MM.yyyy`.
String formatFilterDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}

/// Formats optional filter date; uses [todayLabel] when the day is today.
String formatFilterDateOptional(
  DateTime? date, {
  required String emptyLabel,
  String? todayLabel,
  String? locale,
}) {
  if (date == null) return emptyLabel;
  if (todayLabel != null) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (dateOnly == today) return todayLabel;
  }
  if (locale != null) {
    return DateFormat('dd.MM.yyyy', locale).format(date);
  }
  return formatFilterDate(date);
}

/// Chip label for an active custom date range (or single day).
String formatFilterDateRangeLabel(ConfirmedReservationsFilters filters) {
  final range = filters.apiDateRange;
  final fromLabel = formatFilterDate(range.from);
  final toLabel = formatFilterDate(range.to);
  if (fromLabel == toLabel) return fromLabel;
  return '$fromLabel - $toLabel';
}
