/// Venue-user link from API.
class VenueUser {
  const VenueUser({
    required this.id,
    required this.venueId,
  });

  final String id;
  final String venueId;

  factory VenueUser.fromJson(Map<String, dynamic> json) {
    return VenueUser(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
      };
}
