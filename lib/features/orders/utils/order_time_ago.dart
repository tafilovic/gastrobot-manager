import '../../../l10n/generated/app_localizations.dart';

/// Formats [targetTimeIso] (ISO 8601) as "Pre X minuta" / "Pre X sekundi" relative to now.
String formatOrderTimeAgo(String targetTimeIso, AppLocalizations l10n) {
  final target = DateTime.tryParse(targetTimeIso);
  if (target == null) return l10n.orderTimeAgoMinutes(0);
  final now = DateTime.now();
  final diff = now.difference(target);
  final seconds = diff.inSeconds;
  if (seconds < 60) {
    return l10n.orderTimeAgoSeconds(seconds.clamp(0, 59));
  }
  final minutes = diff.inMinutes;
  return l10n.orderTimeAgoMinutes(minutes);
}
