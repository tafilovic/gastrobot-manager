import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';

/// Maps waiter GET …/waiter/reservations/pending items to [PendingOrder.fromJson] input.
/// API često koristi drugačija polja od kitchen/bar pending porudžbina.
Map<String, dynamic> mapWaiterReservationToPendingOrderJson(
  Map<String, dynamic> raw,
) {
  final m = Map<String, dynamic>.from(raw);

  final id = m['orderId'] ??
      m['order_id'] ??
      m['reservationId'] ??
      m['reservation_id'] ??
      m['id'] ??
      m['requestId'] ??
      m['request_id'];
  m['orderId'] = id?.toString() ?? '';

  if ((m['orderNumber']?.toString() ?? '').isEmpty) {
    m['orderNumber'] = m['referenceCode']?.toString() ??
        m['reference_code']?.toString() ??
        m['code']?.toString() ??
        m['displayReference']?.toString() ??
        m['publicId']?.toString() ??
        m['reservationNumber']?.toString() ??
        m['reservation_number']?.toString() ??
        '';
  }
  if ((m['orderNumber']?.toString() ?? '').isEmpty &&
      m['orderId']?.toString().isNotEmpty == true) {
    m['orderNumber'] = m['orderId'].toString();
  }

  if ((m['targetTime']?.toString() ?? '').isEmpty) {
    final candidates = [
      m['reservationStart'],
      m['reservation_start'],
      m['reservationDate'],
      m['reservation_date'],
      m['scheduledAt'],
      m['scheduled_at'],
      m['appointmentTime'],
      m['startTime'],
      m['start_time'],
      m['dateTime'],
      m['startsAt'],
      m['starts_at'],
    ];
    for (final c in candidates) {
      final s = c?.toString();
      if (s != null && s.isNotEmpty) {
        m['targetTime'] = s;
        break;
      }
    }
    if ((m['targetTime']?.toString() ?? '').isEmpty &&
        m['date'] != null &&
        m['time'] != null) {
      m['targetTime'] = '${m['date']}T${m['time']}';
    }
  }

  final rd = <String, dynamic>{};
  if (m['reservationDetails'] is Map) {
    rd.addAll(
      Map<String, dynamic>.from(m['reservationDetails'] as Map),
    );
  }

  void mergeRegion() {
    for (final k in [
      'region',
      'seatingArea',
      'seating_area',
      'area',
      'location',
      'zone',
      'seatingType',
      'seating_type',
      'tableRegion',
    ]) {
      final v = m[k] ?? rd[k];
      if (v != null && v.toString().isNotEmpty) {
        rd['region'] = v.toString();
        return;
      }
    }
  }

  void mergeParty() {
    for (final k in [
      'partySize',
      'party_size',
      'numberOfGuests',
      'number_of_guests',
      'guestCount',
      'guest_count',
      'guests',
      'numberOfPeople',
      'number_of_people',
      'peopleCount',
    ]) {
      final v = m[k] ?? rd[k];
      if (v != null) {
        final n = v is int ? v : int.tryParse(v.toString());
        if (n != null) {
          rd['partySize'] = n;
          return;
        }
      }
    }
  }

  mergeRegion();
  mergeParty();
  if (rd.isNotEmpty) {
    m['reservationDetails'] = rd;
  }

  m['orderType'] = m['orderType'] ?? m['type'] ?? 'reservation';
  return m;
}

/// Parsira jedan element waiter pending rezervacija u [PendingOrder].
PendingOrder pendingOrderFromWaiterReservationJson(dynamic e) {
  if (e is! Map) {
    return PendingOrder.fromJson(<String, dynamic>{});
  }
  final mapped = mapWaiterReservationToPendingOrderJson(
    Map<String, dynamic>.from(e as Map),
  );
  return PendingOrder.fromJson(mapped);
}
