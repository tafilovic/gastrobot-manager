import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/tables/domain/errors/tables_exception.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/domain/repositories/tables_api.dart';

/// Fetches venue tables from /venues/:venueId/tables.
class TablesRemote implements TablesApi {
  TablesRemote(Dio dio) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<TableModel>> getTables(String venueId) async {
    final url = '${ApiConfig.baseUrl}/venues/$venueId/tables';

    try {
      final response = await _dio.get<List<dynamic>>(
        url,
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null || response.statusCode != 200) {
        return [];
      }

      return response.data!
          .map((e) => TableModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message =
          e.response?.data is Map
              ? (e.response!.data as Map)['message']?.toString()
              : null;
      throw TablesException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<List<ConfirmedReservation>> getActiveReservationsForTable(
    String tableId,
  ) async {
    final url =
        '${ApiConfig.baseUrl}/v1/tables/$tableId/reservations/active';

    try {
      final response = await _dio.get<List<dynamic>>(
        url,
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null || response.statusCode != 200) {
        return [];
      }

      return response.data!
          .whereType<Map<String, dynamic>>()
          .map(ConfirmedReservation.fromJson)
          .toList()
        ..sort((a, b) => a.reservationStart.compareTo(b.reservationStart));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw TablesException(message ?? e.message ?? 'Network error');
    }
  }
}
