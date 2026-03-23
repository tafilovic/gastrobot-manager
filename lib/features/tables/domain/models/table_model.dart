/// Represents the next upcoming reservation for a table.
class TableReservation {
  const TableReservation({
    required this.id,
    required this.startsAt,
    this.reservationNumber,
    this.guestName,
    this.peopleCount,
  });

  final String id;
  final DateTime startsAt;

  /// Public code shown in the chip (e.g. RE3459C) when the API sends it.
  final String? reservationNumber;

  /// Guest display name when provided on [nextReservation].
  final String? guestName;

  final int? peopleCount;

  /// Chip label: [reservationNumber] or a short fallback from [id].
  String get displayChip {
    final n = reservationNumber?.trim();
    if (n != null && n.isNotEmpty) {
      return n;
    }
    final compact = id.replaceAll('-', '');
    if (compact.isEmpty) {
      return '';
    }
    final take = compact.length >= 7 ? 7 : compact.length;
    return compact.substring(0, take).toUpperCase();
  }

  factory TableReservation.fromJson(Map<String, dynamic> json) {
    final rawTime =
        json['startsAt'] as String? ??
        json['startAt'] as String? ??
        json['startTime'] as String? ??
        json['time'] as String? ??
        json['reservationStart'] as String?;

    String? guestName;
    final user = json['user'];
    if (user is Map) {
      final m = Map<String, dynamic>.from(user);
      final fn = (m['firstname'] ?? m['firstName'] ?? '') as String? ?? '';
      final ln = (m['lastname'] ?? m['lastName'] ?? '') as String? ?? '';
      final combined = '$fn $ln'.trim();
      if (combined.isNotEmpty) {
        guestName = combined;
      }
    }
    guestName ??= json['guestName'] as String?;

    int? peopleCount;
    final pc = json['peopleCount'] ?? json['partySize'] ?? json['guests'];
    if (pc is int) {
      peopleCount = pc;
    } else if (pc is num) {
      peopleCount = pc.toInt();
    }

    return TableReservation(
      id: json['id'] as String? ?? '',
      startsAt: rawTime != null ? DateTime.parse(rawTime) : DateTime.now(),
      reservationNumber: json['reservationNumber'] as String? ??
          json['number'] as String? ??
          json['code'] as String?,
      guestName: guestName,
      peopleCount: peopleCount,
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
