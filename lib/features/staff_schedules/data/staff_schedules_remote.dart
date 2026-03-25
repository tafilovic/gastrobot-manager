import 'package:dio/dio.dart';

import 'package:gastrobotmanager/features/staff_schedules/domain/errors/staff_schedules_exception.dart';
import 'package:gastrobotmanager/features/staff_schedules/domain/models/staff_member_schedule.dart';
import 'package:gastrobotmanager/features/staff_schedules/domain/repositories/staff_schedules_api.dart';

/// Remote implementation for [StaffSchedulesApi].
class StaffSchedulesRemote implements StaffSchedulesApi {
  StaffSchedulesRemote(this._dio);

  final Dio _dio;

  @override
  Future<List<StaffMemberSchedule>> getVenueCalendar(String venueId) async {
    final path = '/staff-schedules/venue/$venueId/calendar';
    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        throw const StaffSchedulesException('Invalid response');
      }

      if (response.statusCode != 200) {
        final Object? raw = response.data;
        String? msg;
        if (raw is Map) {
          msg = raw['message']?.toString();
        }
        throw StaffSchedulesException(msg ?? 'Failed to load staff schedules');
      }

      final Object? body = response.data;
      if (body is! List<dynamic>) {
        throw const StaffSchedulesException('Invalid response');
      }

      return body
          .whereType<Map<String, dynamic>>()
          .map(StaffMemberSchedule.fromJson)
          .where((e) => e.user.id.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw StaffSchedulesException(
        message ?? e.message ?? 'Network error',
      );
    }
  }
}
