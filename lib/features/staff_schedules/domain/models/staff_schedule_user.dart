/// Staff member as returned by staff schedule calendar API.
class StaffScheduleUser {
  const StaffScheduleUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.profileImageUrl,
    required this.role,
  });

  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String? profileImageUrl;
  final String role;

  String get displayName {
    final a = firstname.trim();
    final b = lastname.trim();
    if (a.isEmpty && b.isEmpty) return email;
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;
    return '$a $b';
  }

  factory StaffScheduleUser.fromJson(Map<String, dynamic> json) {
    return StaffScheduleUser(
      id: json['id']?.toString() ?? '',
      firstname: json['firstname']?.toString() ?? '',
      lastname: json['lastname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString(),
      role: json['role']?.toString() ?? '',
    );
  }
}
