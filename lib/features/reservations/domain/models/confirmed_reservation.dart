import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';

/// A table embedded in a [ConfirmedReservation].
class ConfirmedReservationTable {
  const ConfirmedReservationTable({required this.id, required this.name});

  final String id;
  final String name;

  factory ConfirmedReservationTable.fromJson(Map<String, dynamic> json) {
    return ConfirmedReservationTable(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

/// The guest who made the reservation.
class ConfirmedReservationUser {
  const ConfirmedReservationUser({
    required this.id,
    required this.firstname,
    required this.lastname,
  });

  final String id;
  final String firstname;
  final String lastname;

  String get fullName => '$firstname $lastname'.trim();

  factory ConfirmedReservationUser.fromJson(Map<String, dynamic> json) {
    return ConfirmedReservationUser(
      id: json['id'] as String,
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
    );
  }
}

/// A confirmed reservation from GET /venues/:venueId/waiter/reservations/confirmed.
class ConfirmedReservation {
  const ConfirmedReservation({
    required this.id,
    required this.reservationNumber,
    required this.reservationStart,
    required this.peopleCount,
    required this.tables,
    required this.type,
    this.user,
    this.assignedTableName,
    this.regionId,
    this.regionTitle,
    this.additionalInfo,
    this.items = const [],
  });

  final String id;
  final String reservationNumber;
  final DateTime reservationStart;
  final int peopleCount;

  /// Reservation type: "classic" | "birthday" | …
  final String type;

  final List<ConfirmedReservationTable> tables;

  /// May be null for system-created or deleted user reservations.
  final ConfirmedReservationUser? user;

  /// Fallback table label when [tables] is empty.
  final String? assignedTableName;

  /// Region id from API (`region.id`); used to restrict table picker to that zone.
  final String? regionId;

  /// Region display name, populated when the API includes region data.
  final String? regionTitle;

  /// Guest note / additional info added to the reservation.
  final String? additionalInfo;

  /// Pre-ordered items (food / drink) linked via the reservation's order.
  /// Empty when the API response does not include order data.
  final List<PendingOrderItem> items;

  /// Comma-separated table names, e.g. "17, 18".
  /// Falls back to [assignedTableName] if the tables array is empty.
  String get tableNamesLabel {
    if (tables.isNotEmpty) {
      return tables.map((t) => t.name).join(', ');
    }
    return assignedTableName ?? '—';
  }

  List<PendingOrderItem> get foodItems =>
      items.where((i) => i.type == 'food').toList();

  List<PendingOrderItem> get drinkItems =>
      items.where((i) => i.type == 'drink').toList();

  factory ConfirmedReservation.fromJson(Map<String, dynamic> json) {
    final rawTables = json['tables'];
    final tables = rawTables is List
        ? rawTables
            .whereType<Map<String, dynamic>>()
            .map(ConfirmedReservationTable.fromJson)
            .toList()
        : <ConfirmedReservationTable>[];

    final rawUser = json['user'];
    final user = rawUser is Map<String, dynamic>
        ? ConfirmedReservationUser.fromJson(rawUser)
        : null;

    // Region: id + display (title, else area)
    final rawRegion = json['region'];
    String? regionId;
    String? regionTitle;
    if (rawRegion is Map<String, dynamic>) {
      final idVal = rawRegion['id'];
      if (idVal != null && idVal.toString().trim().isNotEmpty) {
        regionId = idVal.toString();
      }
      final title = rawRegion['title'] as String?;
      final area = rawRegion['area'] as String?;
      regionTitle = (title != null && title.isNotEmpty) ? title : area;
    }

    // Items: from linked order if present
    final rawOrder = json['order'];
    List<PendingOrderItem> items = const [];
    if (rawOrder is Map<String, dynamic>) {
      final rawItems = rawOrder['items'];
      if (rawItems is List) {
        items = rawItems
            .whereType<Map<String, dynamic>>()
            .map(PendingOrderItem.fromJson)
            .toList();
      }
    }

    return ConfirmedReservation(
      id: json['id'] as String,
      reservationNumber: json['reservationNumber'] as String? ?? '',
      reservationStart: DateTime.parse(
        json['reservationStart'] as String,
      ),
      peopleCount: (json['peopleCount'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'classic',
      tables: tables,
      assignedTableName: json['assignedTableName'] as String?,
      regionId: regionId,
      regionTitle: regionTitle,
      additionalInfo: json['additionalInfo'] as String?,
      user: user,
      items: items,
    );
  }
}
