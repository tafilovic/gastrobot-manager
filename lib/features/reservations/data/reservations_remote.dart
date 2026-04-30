import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/models/paginated_result.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/errors/reservations_exception.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservations_api.dart';

/// Fetches reservation requests by role.
/// Waiter: GET …/v1/venues/:venueId/reservations?status=pending → [PendingReservation]
/// Kitchen/bar: …/pending?source=reservation
class ReservationsRemote implements ReservationsApi {
  ReservationsRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;
  static const String _sortBy = 'createdAt';
  static const String _sortOrder = 'DESC';

  static List<dynamic> _listFromResponse(dynamic data) {
    if (data == null) return [];
    if (data is List<dynamic>) return data;
    if (data is List) return List<dynamic>.from(data);
    if (data is Map) {
      for (final key in [
        'reservations',
        'orders',
        'data',
        'items',
        'pendingReservations',
        'result',
        'content',
      ]) {
        final v = data[key];
        if (v is List<dynamic>) return v;
        if (v is List) return List<dynamic>.from(v);
      }
    }
    return [];
  }

  String _kitchenBarUrl(String venueId, ProfileType profileType) {
    if (profileType == ProfileType.bar) {
      return '/venues/$venueId/bar/pending';
    }
    return '/venues/$venueId/kitchen/pending';
  }

  @override
  Future<PaginatedResult<PendingReservation>> getWaiterPendingReservations({
    required String venueId,
    required int page,
    required int limit,
  }) async {
    const path = '/v1/venues';
    final endpoint = '$path/$venueId/reservations';

    try {
      final response = await _dio.get<dynamic>(
        endpoint,
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
          'status': 'pending',
          'sortBy': _sortBy,
          'sortOrder': _sortOrder,
        },
        options: Options(
          validateStatus: (int? status) => status != null && status < 400,
        ),
      );

      if (response.statusCode != 200) {
        final data = response.data;
        final msg = data is Map ? data['message']?.toString() : null;
        throw ReservationsException(msg ?? 'Failed to load reservations');
      }

      final payload = response.data;
      final raw = _listFromResponse(payload);
      final totalRaw = payload is Map ? payload['total'] : null;
      final total = totalRaw is int
          ? totalRaw
          : int.tryParse(totalRaw?.toString() ?? '') ?? 0;
      final items = raw
          .whereType<Map>()
          .map((e) => PendingReservation.fromJson(Map<String, dynamic>.from(e)))
          .where((r) => r.id.isNotEmpty)
          .toList();

      return PaginatedResult<PendingReservation>(
        items: items,
        total: total,
        page: page,
        limit: limit,
      );
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ReservationsException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<List<PendingOrder>> getKitchenBarReservationRequests(
    String venueId,
    ProfileType profileType,
  ) async {
    final path = _kitchenBarUrl(venueId, profileType);
    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: {'source': 'reservation'},
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        return [];
      }

      if (response.statusCode != 200) {
        return [];
      }

      return (response.data!)
          .map((e) => PendingOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ReservationsException(message ?? e.message ?? 'Network error');
    }
  }
}
