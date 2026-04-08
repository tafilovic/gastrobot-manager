/// Region nested object on GET …/waiter/reservations/pending items.
class PendingReservationRegion {
  const PendingReservationRegion({
    required this.id,
    this.title,
    this.area,
    this.venueId,
  });

  final String id;
  final String? title;
  final String? area;
  final String? venueId;

  factory PendingReservationRegion.fromJson(Map<String, dynamic> json) {
    return PendingReservationRegion(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString(),
      area: json['area']?.toString(),
      venueId: json['venueId']?.toString(),
    );
  }
}
