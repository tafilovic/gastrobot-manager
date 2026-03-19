import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/regions/domain/errors/regions_exception.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/features/regions/domain/repositories/regions_api.dart';

/// Fetches all regions for the authenticated user from GET /regions,
/// then filters the result to only those belonging to [venueId].
class RegionsRemote implements RegionsApi {
  RegionsRemote(Dio dio) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<RegionModel>> getRegions(String venueId) async {
    final url = '${ApiConfig.baseUrl}/regions';

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
          .map(RegionModel.fromJson)
          .where((r) => r.venueId == venueId)
          .toList();
    } on DioException catch (e) {
      final message =
          e.response?.data is Map
              ? (e.response!.data as Map)['message']?.toString()
              : null;
      throw RegionsException(message ?? e.message ?? 'Network error');
    }
  }
}
