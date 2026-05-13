import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/zones/domain/errors/zones_exception.dart';
import 'package:gastrobotmanager/features/zones/domain/models/create_zone_order_request.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_model.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_orders_filters.dart';
import 'package:gastrobotmanager/features/zones/domain/repositories/zones_api.dart';

/// Fetches venue zones from /venues/:venueId/tables.
class ZonesRemote implements ZonesApi {
  ZonesRemote(Dio dio) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<ZoneModel>> getZones(String venueId) async {
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
          .map((e) => ZoneModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message =
          e.response?.data is Map
              ? (e.response!.data as Map)['message']?.toString()
              : null;
      throw ZonesException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<List<ConfirmedReservation>> getActiveReservationsForZone(
    String zoneId,
  ) async {
    final url =
        '${ApiConfig.baseUrl}/v1/tables/$zoneId/reservations/active';

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
      throw ZonesException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<List<PendingOrder>> getOrdersForZone(
    String zoneId,
    ZoneOrdersFilters filters,
  ) async {
    final url = '${ApiConfig.baseUrl}/v1/tables/$zoneId/orders';
    final queryParameters = <String, dynamic>{
      'startDate': filters.dateFrom.toIso8601String(),
      'endDate': filters.dateTo.toIso8601String(),
      'minPrice': filters.apiMinPrice,
      'maxPrice': filters.apiMaxPrice,
    };
    if (filters.orderStatus != null && filters.orderStatus!.isNotEmpty) {
      queryParameters['status'] = filters.orderStatus;
    }
    if (filters.orderType != null && filters.orderType!.isNotEmpty) {
      queryParameters['type'] = filters.orderType;
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        url,
        queryParameters: queryParameters,
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null || response.statusCode != 200) {
        return [];
      }

      return response.data!
          .map(
            (e) => PendingOrder.fromJson(
              e is Map
                  ? Map<String, dynamic>.from(e)
                  : <String, dynamic>{},
            ),
          )
          .where((o) => o.orderId.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ZonesException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<void> createVenueOrder(
    String venueId,
    CreateZoneOrderRequest request,
  ) async {
    final url = '${ApiConfig.baseUrl}/v1/venues/$venueId/orders';

    try {
      final response = await _dio.post<dynamic>(
        url,
        data: request.toJson(),
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      final code = response.statusCode ?? 0;
      if (code < 200 || code >= 300) {
        throw ZonesException('Unexpected response ($code)');
      }
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw ZonesException(message ?? e.message ?? 'Network error');
    }
  }
}
