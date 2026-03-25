/// Failure loading staff schedules from API.
class StaffSchedulesException implements Exception {
  const StaffSchedulesException(this.message);

  final String message;

  @override
  String toString() => 'StaffSchedulesException: $message';
}
