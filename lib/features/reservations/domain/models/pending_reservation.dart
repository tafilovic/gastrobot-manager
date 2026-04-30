import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation_region.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation_user.dart';

/// Pending reservation from GET `/v1/venues/:venueId/reservations?status=pending`.
class PendingReservation {
  const PendingReservation({
    required this.id,
    required this.reservationNumber,
    required this.reservationStart,
    required this.peopleCount,
    required this.type,
    required this.status,
    this.reservationEnd,
    this.additionalInfo,
    this.assignedTableName,
    this.user,
    this.region,
    this.items = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String reservationNumber;
  final String reservationStart;
  final String? reservationEnd;
  final int peopleCount;
  final String type;
  final String status;
  final String? additionalInfo;
  final String? assignedTableName;
  final PendingReservationUser? user;
  final PendingReservationRegion? region;
  final List<PendingOrderItem> items;
  final String? createdAt;
  final String? updatedAt;

  /// Display label for app bar / chips (public code).
  String get displayReference =>
      reservationNumber.isNotEmpty ? reservationNumber : id;

  /// Region label for cards and details — API `region.title`.
  String? get regionTitle => region?.title;

  factory PendingReservation.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    final orderItemsList = json['orderItems'] as List<dynamic>?;
    final rawOrder = json['order'];
    final nestedOrderItemsList = rawOrder is Map ? rawOrder['orderItems'] as List<dynamic>? : null;
    final rawItems = (orderItemsList != null && orderItemsList.isNotEmpty)
        ? orderItemsList
        : (nestedOrderItemsList != null && nestedOrderItemsList.isNotEmpty)
            ? nestedOrderItemsList
        : (itemsList ?? const <dynamic>[]);

    PendingReservationRegion? regionObj;
    final rawRegion = json['region'];
    if (rawRegion is Map<String, dynamic>) {
      regionObj = PendingReservationRegion.fromJson(rawRegion);
    } else if (rawRegion is Map) {
      regionObj =
          PendingReservationRegion.fromJson(Map<String, dynamic>.from(rawRegion));
    }

    PendingReservationUser? userObj;
    final rawUser = json['user'];
    if (rawUser is Map<String, dynamic>) {
      userObj = PendingReservationUser.fromJson(rawUser);
    } else if (rawUser is Map) {
      userObj =
          PendingReservationUser.fromJson(Map<String, dynamic>.from(rawUser));
    }

    final peopleRaw =
        json['peopleCount'] ?? json['partySize'] ?? json['party_size'];
    final people = peopleRaw is int
        ? peopleRaw
        : int.tryParse(peopleRaw?.toString() ?? '') ?? 0;

    return PendingReservation(
      id: json['id']?.toString() ?? '',
      reservationNumber: json['reservationNumber']?.toString() ?? '',
      reservationStart: json['reservationStart']?.toString() ?? '',
      reservationEnd: json['reservationEnd']?.toString(),
      peopleCount: people,
      type: json['type']?.toString() ?? 'classic',
      status: json['status']?.toString() ?? 'pending',
      additionalInfo: json['additionalInfo']?.toString(),
      assignedTableName: json['assignedTableName']?.toString(),
      user: userObj,
      region: regionObj,
      items: rawItems
          .map((e) => PendingOrderItem.fromJson(
                e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{},
              ))
          .toList(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}
