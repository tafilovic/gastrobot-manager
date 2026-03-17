/// Represents the next upcoming reservation for a table.
class TableReservation {
  const TableReservation({required this.id, required this.startsAt});

  final String id;
  final DateTime startsAt;

  factory TableReservation.fromJson(Map<String, dynamic> json) {
    final rawTime =
        json['startsAt'] as String? ??
        json['startAt'] as String? ??
        json['startTime'] as String? ??
        json['time'] as String?;

    return TableReservation(
      id: json['id'] as String? ?? '',
      startsAt: rawTime != null ? DateTime.parse(rawTime) : DateTime.now(),
    );
  }
}

/// A single venue table from the /venues/:id/tables endpoint.
class TableModel {
  const TableModel({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.venueId,
    required this.status,
    this.regionId,
    this.code,
    this.currentUserName,
    this.nextReservation,
  });

  final String id;

  /// Table number (string, e.g. "1", "31").
  final String name;

  /// Type: "table" | "room" | "sunbed"
  final String type;

  final int capacity;
  final String venueId;
  final String? regionId;
  final String? code;
  final String status;
  final String? currentUserName;
  final TableReservation? nextReservation;

  bool get isFree => status == 'free';

  factory TableModel.fromJson(Map<String, dynamic> json) {
    final rawReservation = json['nextReservation'];

    return TableModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? 'table',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      venueId: json['venueId'] as String,
      regionId: json['regionId'] as String?,
      code: json['code'] as String?,
      status: json['status'] as String? ?? 'free',
      currentUserName: json['currentUserName'] as String?,
      nextReservation:
          rawReservation is Map<String, dynamic>
              ? TableReservation.fromJson(rawReservation)
              : null,
    );
  }
}
