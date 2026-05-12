class VenueSettings {
  const VenueSettings({
    required this.waiterActsAsBartender,
  });

  final bool waiterActsAsBartender;

  factory VenueSettings.fromJson(Map<String, dynamic> json) {
    return VenueSettings(
      waiterActsAsBartender: json['waiterActsAsBartender'] as bool? ?? false,
    );
  }
}
