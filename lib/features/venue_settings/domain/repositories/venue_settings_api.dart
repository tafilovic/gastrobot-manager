import 'package:gastrobotmanager/features/venue_settings/domain/models/venue_settings.dart';

abstract class VenueSettingsApi {
  Future<VenueSettings> getVenueSettings(String venueId);
}
