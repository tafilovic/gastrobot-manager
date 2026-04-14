import 'package:intl/intl.dart';

import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// [intl] does not ship date symbols for every app language (e.g. Maltese `mt`).
String _intlDateFormatLocale(String? languageCode) {
  final requested = (languageCode ?? 'sr').trim().toLowerCase();
  if (requested.isNotEmpty && DateFormat.localeExists(requested)) {
    return requested;
  }
  if (DateFormat.localeExists('en')) {
    return 'en';
  }
  return 'sr';
}

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

  final formatter = DateFormat(
    'dd.MM.yyyy. (EEEE)',
    _intlDateFormatLocale(locale),
  );
  return formatter.format(date);
}

/// Formats time from [targetTimeIso] as "HH:mm".
String formatReservationTime(String targetTimeIso) {
  final date = DateTime.tryParse(targetTimeIso);
  if (date == null) return '';
  return DateFormat('HH:mm').format(date);
}
