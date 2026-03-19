import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/reservations/domain/errors/reservations_exception.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/confirmed_reservations_api.dart';

class ConfirmedReservationsRemote implements ConfirmedReservationsApi {
  ConfirmedReservationsRemote(Dio dio) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<ConfirmedReservation>> getConfirmed(String venueId) async {
    final url =
        '${ApiConfig.baseUrl}/venues/$venueId/waiter/reservations/confirmed';

    try {
      final response = await _dio.get<List<dynamic>>(
        url,
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null || response.statusCode != 200) return [];

      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(ConfirmedReservation.fromJson)
          .toList()
        ..sort((a, b) => a.reservationStart.compareTo(b.reservationStart));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ReservationsException(message ?? e.message ?? 'Network error');
    }
  }
}
