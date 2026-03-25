import 'package:gastrobotmanager/core/models/user_venue.dart';

/// Venue-user link from auth API.
///
/// New shape: `{ "id", "venue": { "id", "name", "currency" } }`.
/// Legacy (persisted session): `{ "id", "venueId" }`.
class VenueUser {
  const VenueUser({
    required this.id,
    required this.venueId,
    this.venue,
  });

  /// Membership id (venue-user row).
  final String id;

  /// Venue id for API paths; from nested [venue] or legacy `venueId`.
  final String venueId;

  final UserVenue? venue;

  factory VenueUser.fromJson(Map<String, dynamic> json) {
    UserVenue? venue;
    final venueRaw = json['venue'];
    if (venueRaw is Map<String, dynamic>) {
      venue = UserVenue.fromJson(venueRaw);
    }
    final venueId = json['venueId'] as String? ?? venue?.id ?? '';
    return VenueUser(
      id: json['id']?.toString() ?? '',
      venueId: venueId,
      venue: venue,
    );
  }

  Map<String, dynamic> toJson() {
    final v = venue;
    if (v != null) {
      return {
        'id': id,
        'venue': v.toJson(),
      };
    }
    return {
      'id': id,
      'venueId': venueId,
    };
  }

  bool _sameMembershipAs(VenueUser other) {
    if (id.isNotEmpty && other.id.isNotEmpty && id == other.id) {
      return true;
    }
    if (venueId.isNotEmpty &&
        other.venueId.isNotEmpty &&
        venueId == other.venueId) {
      return true;
    }
    return false;
  }

  /// GET /users/me often omits nested [venue] or [venue.currency]. Reuse from
  /// [previous] when it is the same venue-user row (login/session still has it).
  VenueUser withVenueMetadataFromPrevious(VenueUser? previous) {
    if (previous == null || !_sameMembershipAs(previous)) {
      return this;
    }
    final v = venue;
    final pv = previous.venue;
    final hasIncomingCurrency =
        v?.currency != null && v!.currency!.isNotEmpty;
    if (hasIncomingCurrency) {
      return this;
    }
    if (pv == null) {
      return this;
    }
    if (v == null) {
      return VenueUser(
        id: id,
        venueId: venueId.isNotEmpty ? venueId : previous.venueId,
        venue: pv,
      );
    }
    final prevCur = pv.currency;
    if (prevCur == null || prevCur.isEmpty) {
      if (v.id.isEmpty && v.name.isEmpty) {
        return VenueUser(id: id, venueId: venueId, venue: pv);
      }
      return this;
    }
    return VenueUser(
      id: id,
      venueId: venueId,
      venue: UserVenue(
        id: v.id.isNotEmpty ? v.id : pv.id,
        name: v.name.isNotEmpty ? v.name : pv.name,
        currency: prevCur,
      ),
    );
  }
}
