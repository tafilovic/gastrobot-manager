import 'package:gastrobotmanager/features/staff_schedules/domain/models/staff_schedule_user.dart';
import 'package:gastrobotmanager/features/staff_schedules/domain/models/staff_shift.dart';

/// One user's weekly shifts from GET …/staff-schedules/venue/:id/calendar.
class StaffMemberSchedule {
  const StaffMemberSchedule({
    required this.user,
    required this.shifts,
  });

  final StaffScheduleUser user;
  final List<StaffShift> shifts;

  factory StaffMemberSchedule.fromJson(Map<String, dynamic> json) {
    final userRaw = json['user'];
    final shiftsRaw = json['shifts'];
    final user = userRaw is Map<String, dynamic>
        ? StaffScheduleUser.fromJson(userRaw)
        : StaffScheduleUser(
            id: '',
            firstname: '',
            lastname: '',
            email: '',
            role: '',
          );
    final shifts = <StaffShift>[];
    if (shiftsRaw is List<dynamic>) {
      for (final e in shiftsRaw) {
        if (e is Map<String, dynamic>) {
          shifts.add(StaffShift.fromJson(e));
        }
      }
    }
    return StaffMemberSchedule(user: user, shifts: shifts);
  }

  /// Map weekday (1–7) → shift for that day, if any.
  Map<int, StaffShift> get shiftsByWeekday {
    final map = <int, StaffShift>{};
    for (final s in shifts) {
      if (s.isActive) {
        map[s.weekdayIndex] = s;
      }
    }
    return map;
  }
}
