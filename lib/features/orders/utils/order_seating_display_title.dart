import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/zones/utils/zone_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Localized seating label (Room / Sunbed / Table + number) for a [PendingOrder].
String orderSeatingDisplayTitle(AppLocalizations l10n, PendingOrder order) {
  return zoneQualifiedTitleForSeating(
    l10n,
    displayName: order.tableNumber,
    seatingType: order.tableType,
  );
}
