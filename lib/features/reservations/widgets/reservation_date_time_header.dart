import 'package:flutter/material.dart';

/// Horizontal header row shown at the top of reservation detail screens.
///
/// Layout:  [calendar icon]  dateStr  <Spacer>  timeStr  [access_time icon]
///
/// All text and icons are coloured with [accentColor].
class ReservationDateTimeHeader extends StatelessWidget {
  const ReservationDateTimeHeader({
    super.key,
    required this.dateStr,
    required this.timeStr,
    required this.accentColor,
  });

  final String dateStr;
  final String timeStr;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: accentColor,
          fontWeight: FontWeight.w600,
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 20, color: accentColor),
          const SizedBox(width: 8),
          Text(dateStr, style: textStyle),
          const Spacer(),
          Text(timeStr, style: textStyle),
          const SizedBox(width: 6),
          Icon(Icons.access_time, size: 20, color: accentColor),
        ],
      ),
    );
  }
}
