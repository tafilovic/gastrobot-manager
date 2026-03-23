import 'package:flutter/material.dart';

import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/utils/group_tables_by_display_category.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

IconData tableDisplayCategoryIcon(TableDisplayCategory category) {
  return switch (category) {
    TableDisplayCategory.room => Icons.meeting_room_outlined,
    TableDisplayCategory.sunbed => Icons.beach_access_outlined,
    TableDisplayCategory.table => Icons.table_restaurant_outlined,
  };
}

/// Maps API `table.type` / order payload seating kind to a display category.
TableDisplayCategory tableDisplayCategoryFromApiType(String? type) {
  switch (type?.trim().toLowerCase()) {
    case 'room':
      return TableDisplayCategory.room;
    case 'sunbed':
      return TableDisplayCategory.sunbed;
    default:
      return TableDisplayCategory.table;
  }
}

/// Localized title for a seating spot (e.g. "Room 3", "Sunbed 12", "Table 5").
String seatingQualifiedTitleForSeating(
  AppLocalizations l10n, {
  required String displayName,
  String? seatingType,
}) {
  switch (tableDisplayCategoryFromApiType(seatingType)) {
    case TableDisplayCategory.room:
      return l10n.seatingNumberRoom(displayName);
    case TableDisplayCategory.sunbed:
      return l10n.seatingNumberSunbed(displayName);
    case TableDisplayCategory.table:
      return l10n.seatingNumberTable(displayName);
  }
}

/// Title line for a venue table/room/sunbed (e.g. "Room 3", "Sunbed 12").
String seatingQualifiedTitle(AppLocalizations l10n, TableModel table) {
  return seatingQualifiedTitleForSeating(
    l10n,
    displayName: table.name,
    seatingType: table.type,
  );
}
