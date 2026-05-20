import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/filter/filter_form_fields.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/features/reservations/utils/region_filter_label.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_region_picker_dialog.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Shared unique code + region fields for reservation filter screens.
class ReservationCodeRegionFilterFields extends StatelessWidget {
  const ReservationCodeRegionFilterFields({
    super.key,
    required this.codeController,
    required this.selectedRegionId,
    required this.regions,
    required this.onRegionSelected,
  });

  final TextEditingController codeController;
  final String? selectedRegionId;
  final List<RegionModel> regions;
  final ValueChanged<String?> onRegionSelected;

  Future<void> _openRegionPicker(BuildContext context, AppLocalizations l10n) async {
    final result = await showReservationRegionPickerDialog(
      context: context,
      l10n: l10n,
      regions: regions,
      selectedRegionId: selectedRegionId,
    );
    if (result != null) {
      onRegionSelected(result.regionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilterFieldLabel(l10n.filterUniqueCode),
        const SizedBox(height: 8),
        FilterTextField(
          controller: codeController,
          hint: l10n.filterUniqueCodeHint,
          prefixText: '# ',
        ),
        const SizedBox(height: 16),
        FilterFieldLabel(l10n.filterRegionLabel),
        const SizedBox(height: 8),
        FilterTapField(
          value: allRegionsOrTitle(l10n, regions, selectedRegionId),
          trailing: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
            size: 22,
          ),
          onTap: () => _openRegionPicker(context, l10n),
        ),
      ],
    );
  }
}
