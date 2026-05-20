import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/models/paginated_result.dart';
import 'package:gastrobotmanager/features/reservations/domain/errors/reservations_exception.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/confirmed_reservations_api.dart';

class ConfirmedReservationsRemote implements ConfirmedReservationsApi {
  ConfirmedReservationsRemote(Dio dio) : _dio = dio;

  final Dio _dio;
  static const String _sortBy = 'reservationStart';
  static const String _sortOrder = 'DESC';

  @override
  Future<PaginatedResult<ConfirmedReservation>> getConfirmed({
    required String venueId,
    required int page,
    required int limit,
    ConfirmedReservationsFilters? filters,
  }) async {
    final url = '${ApiConfig.baseUrl}/v1/venues/$venueId/reservations';
    final range =
        filters?.apiDateRange ?? ConfirmedReservationsFilters.defaultApiDateRange();

    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
      'status': 'confirmed',
      'sortBy': _sortBy,
      'sortOrder': _sortOrder,
      'from': range.from.toIso8601String(),
      'to': range.to.toIso8601String(),
    };

    final reservationNumber = filters?.trimmedReservationNumber;
    if (reservationNumber != null) {
      queryParameters['reservationNumber'] = reservationNumber;
    }
    final regionId = filters?.regionId;
    if (regionId != null && regionId.isNotEmpty) {
      queryParameters['regionId'] = regionId;
    }

    try {
      final response = await _dio.get<dynamic>(
        url,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.statusCode != 200) {
        return PaginatedResult<ConfirmedReservation>(
          items: const [],
          total: 0,
          page: page,
          limit: limit,
        );
      }

      final payload = response.data;
      if (payload is! Map<String, dynamic>) {
        return PaginatedResult<ConfirmedReservation>(
          items: const [],
          total: 0,
          page: page,
          limit: limit,
        );
      }

      final data = payload['data'];
      final totalRaw = payload['total'];
      final total = totalRaw is int
          ? totalRaw
          : int.tryParse(totalRaw?.toString() ?? '') ?? 0;
      final items = data is List
          ? data
                .whereType<Map>()
                .map((e) => ConfirmedReservation.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <ConfirmedReservation>[];

      return PaginatedResult<ConfirmedReservation>(
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
}
