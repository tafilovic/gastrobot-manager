import 'package:dio/dio.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/features/venue_settings/domain/models/venue_settings.dart';
import 'package:gastrobotmanager/features/venue_settings/domain/repositories/venue_settings_api.dart';

class VenueSettingsRemote implements VenueSettingsApi {
  VenueSettingsRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<VenueSettings> getVenueSettings(String venueId) async {
    final response = await _dio.get<dynamic>(
      '/v1/venues/$venueId/settings',
      options: Options(
        validateStatus: (status) => status != null && status < 400,
      ),
    );
    final data = response.data;
    if (data is Map) {
      return VenueSettings.fromJson(Map<String, dynamic>.from(data));
    }
    return const VenueSettings(waiterActsAsBartender: false);
  }
}
