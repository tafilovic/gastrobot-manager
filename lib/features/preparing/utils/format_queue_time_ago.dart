import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Formats [targetTimeIso] (ISO 8601) relative to now for queue/preparing.
String formatQueueTimeAgo(String targetTimeIso, AppLocalizations l10n) {
  final target = DateTime.tryParse(targetTimeIso);
  if (target == null) return l10n.orderTimeAgoMinutes(0);
  final now = DateTime.now();
  final diff = now.difference(target);
  final days = diff.inDays;
  final hours = diff.inHours;
  final minutes = diff.inMinutes;
  final seconds = diff.inSeconds;
  if (days >= 1) {
    return l10n.orderTimeAgoDays(days);
  }
  if (hours >= 1) {
    final mins = minutes - (hours * 60);
    return l10n.orderTimeAgoHoursMinutes(hours, mins);
  }
  if (minutes >= 1) {
    return l10n.orderTimeAgoMinutes(minutes);
  }
  return l10n.orderTimeAgoSeconds(seconds.clamp(0, 59));
}
