import 'package:gastrobotmanager/features/staff_schedules/domain/models/staff_member_schedule.dart';

/// Fetches venue staff shift calendar.
abstract class StaffSchedulesApi {
  /// GET /staff-schedules/venue/{venueId}/calendar
  Future<List<StaffMemberSchedule>> getVenueCalendar(String venueId);
}
