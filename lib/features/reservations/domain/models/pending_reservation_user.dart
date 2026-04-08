/// Guest user on a pending reservation response.
class PendingReservationUser {
  const PendingReservationUser({
    required this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
  });

  final String id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phoneNumber;
  final String? profileImageUrl;

  factory PendingReservationUser.fromJson(Map<String, dynamic> json) {
    return PendingReservationUser(
      id: json['id']?.toString() ?? '',
      firstname: json['firstname']?.toString(),
      lastname: json['lastname']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
    );
  }

  String? get fullName {
    final f = firstname?.trim();
    final l = lastname?.trim();
    if ((f == null || f.isEmpty) && (l == null || l.isEmpty)) return null;
    return [if (f != null && f.isNotEmpty) f, if (l != null && l.isNotEmpty) l]
        .join(' ');
  }
}
