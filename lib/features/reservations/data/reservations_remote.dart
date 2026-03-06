import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/errors/reservations_exception.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservations_api.dart';

/// Fetches reservation requests by role from panel API.
class ReservationsRemote implements ReservationsApi {
  ReservationsRemote([Dio? dio])
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  String _requestsUrl(String venueId, ProfileType profileType) {
    if (profileType == ProfileType.waiter) {
      return '${ApiConfig.baseUrl}/venues/$venueId/bar/pending';
    }
    if (profileType == ProfileType.bar) {
      return '${ApiConfig.baseUrl}/venues/$venueId/bar/pending';
    }
    return '${ApiConfig.baseUrl}/venues/$venueId/kitchen/pending';
  }

  @override
  Future<List<PendingOrder>> getRequests(
    String venueId,
    ProfileType profileType,
  ) async {
    final url = _requestsUrl(venueId, profileType);

    try {
      final response = await _dio.get<List<dynamic>>(
        url,
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
