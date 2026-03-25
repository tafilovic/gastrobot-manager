import 'package:gastrobotmanager/features/staff_schedules/domain/models/staff_shift_region.dart';

/// Single shift entry (day + time range) from staff schedule API.
class StaffShift {
  const StaffShift({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.region,
    required this.isActive,
  });

  final String id;

  /// Lowercase English weekday: monday, tuesday, …
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final StaffShiftRegion? region;
  final bool isActive;

  /// Dart [DateTime.weekday]: 1 = Monday … 7 = Sunday.
  int get weekdayIndex {
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

  factory StaffShift.fromJson(Map<String, dynamic> json) {
    final regionRaw = json['region'];
    return StaffShift(
      id: json['id']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? 'monday',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      region: regionRaw is Map<String, dynamic>
          ? StaffShiftRegion.fromJson(regionRaw)
          : null,
      isActive: json['isActive'] == true,
    );
  }
}
