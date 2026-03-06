import 'package:intl/intl.dart';

import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Formats [targetTimeIso] for reservation card: "Danas" or "dd.MM.yyyy. (Weekday)".
String formatReservationDate(
  String targetTimeIso,
  AppLocalizations l10n, {
  String? locale,
}) {
  final date = DateTime.tryParse(targetTimeIso);
  if (date == null) return targetTimeIso;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final other = DateTime(date.year, date.month, date.day);

  if (other == today) {
    return l10n.reservationToday;
  }

  final formatter = DateFormat('dd.MM.yyyy. (EEEE)', locale ?? 'sr');
  return formatter.format(date);
}

/// Formats time from [targetTimeIso] as "HH:mm".
String formatReservationTime(String targetTimeIso) {
  final date = DateTime.tryParse(targetTimeIso);
  if (date == null) return '';
  return DateFormat('HH:mm').format(date);
}
