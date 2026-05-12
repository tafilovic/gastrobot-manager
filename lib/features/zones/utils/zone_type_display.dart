import 'package:flutter/material.dart';

import 'package:gastrobotmanager/features/zones/domain/models/zone_model.dart';
import 'package:gastrobotmanager/features/zones/utils/group_zones_by_display_category.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

IconData zoneDisplayCategoryIcon(ZoneDisplayCategory category) {
  return switch (category) {
    ZoneDisplayCategory.room => Icons.meeting_room_outlined,
    ZoneDisplayCategory.sunbed => Icons.beach_access_outlined,
    ZoneDisplayCategory.table => Icons.table_restaurant_outlined,
  };
}

/// Maps API `table.type` / order payload seating kind to a display category.
ZoneDisplayCategory zoneDisplayCategoryFromApiType(String? type) {
  switch (type?.trim().toLowerCase()) {
    case 'room':
      return ZoneDisplayCategory.room;
    case 'sunbed':
      return ZoneDisplayCategory.sunbed;
    default:
      return ZoneDisplayCategory.table;
  }
}

/// Localized title for a seating spot (e.g. "Room 3", "Sunbed 12", "Table 5").
String zoneQualifiedTitleForSeating(
  AppLocalizations l10n, {
  required String displayName,
  String? seatingType,
}) {
  switch (zoneDisplayCategoryFromApiType(seatingType)) {
    case ZoneDisplayCategory.room:
      return l10n.seatingNumberRoom(displayName);
    case ZoneDisplayCategory.sunbed:
      return l10n.seatingNumberSunbed(displayName);
    case ZoneDisplayCategory.table:
      return l10n.seatingNumberTable(displayName);
  }
}

/// Title line for a venue table/room/sunbed (e.g. "Room 3", "Sunbed 12").
String zoneQualifiedTitle(AppLocalizations l10n, ZoneModel table) {
  return zoneQualifiedTitleForSeating(
    l10n,
    displayName: table.name,
    seatingType: table.type,
  );
}
