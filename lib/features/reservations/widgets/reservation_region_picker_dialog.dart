import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Non-null when the user picked a region; dialog dismiss returns null.
class ReservationRegionPickerResult {
  const ReservationRegionPickerResult({required this.regionId});

  /// `null` means all regions.
  final String? regionId;
}

/// Centered radio dialog for region filter. Returns null if dismissed.
Future<ReservationRegionPickerResult?> showReservationRegionPickerDialog({
  required BuildContext context,
  required AppLocalizations l10n,
  required List<RegionModel> regions,
  required String? selectedRegionId,
}) {
  return showDialog<ReservationRegionPickerResult>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.filterRegionLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    RadioListTile<String?>(
                      title: Text(l10n.filterAllRegions),
                      value: null,
                      groupValue: selectedRegionId,
                      onChanged: (value) => Navigator.pop(
                        ctx,
                        ReservationRegionPickerResult(regionId: value),
                      ),
                    ),
                    ...regions.map(
                      (r) => RadioListTile<String?>(
                        title: Text(r.title),
                        value: r.id,
                        groupValue: selectedRegionId,
                        onChanged: (value) => Navigator.pop(
                          ctx,
                          ReservationRegionPickerResult(regionId: value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
