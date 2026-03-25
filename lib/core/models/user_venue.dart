/// Venue summary nested under login `venueUsers[].venue`.
class UserVenue {
  const UserVenue({
    required this.id,
    required this.name,
    this.currency,
  });

  final String id;
  final String name;
  final String? currency;

  factory UserVenue.fromJson(Map<String, dynamic> json) {
    return UserVenue(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      currency: json['currency']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (currency != null && currency!.isNotEmpty) 'currency': currency,
      };
}
