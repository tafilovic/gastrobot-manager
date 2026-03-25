/// Region attached to a shift in the staff schedule API.
class StaffShiftRegion {
  const StaffShiftRegion({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  factory StaffShiftRegion.fromJson(Map<String, dynamic> json) {
    return StaffShiftRegion(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}
