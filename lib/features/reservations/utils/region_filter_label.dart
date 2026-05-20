import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Title for [regionId], or [fallback] when unknown / missing.
String regionFilterLabel(
  List<RegionModel> regions,
  String? regionId, {
  required String fallback,
}) {
  if (regionId == null) return fallback;
  for (final region in regions) {
    if (region.id == regionId) return region.title;
  }
  return fallback;
}

String allRegionsOrTitle(
  AppLocalizations l10n,
  List<RegionModel> regions,
  String? selectedRegionId,
) {
  return regionFilterLabel(
    regions,
    selectedRegionId,
    fallback: l10n.filterAllRegions,
  );
}
