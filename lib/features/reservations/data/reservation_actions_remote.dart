import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/reservations/domain/errors/reservations_exception.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservation_actions_api.dart';

class ReservationActionsRemote implements ReservationActionsApi {
  ReservationActionsRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<void> rejectReservation({
    required String venueId,
    required String reservationId,
    required String reason,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        '/v1/venues/$venueId/reservations/$reservationId/reject',
        data: {'reason': reason},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 400,
        ),
      );
      if (response.statusCode != 200) {
        final data = response.data;
        final msg = data is Map ? data['message']?.toString() : null;
        throw ReservationsException(msg ?? 'Failed to reject reservation');
      }
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ReservationsException(message ?? e.message ?? 'Network error');
    }
  }
}

