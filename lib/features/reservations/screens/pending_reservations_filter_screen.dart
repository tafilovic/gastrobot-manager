import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/filter/filter_screen_footer.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_code_region_filter_fields.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Filter screen for pending reservation requests: unique code and region.
/// Pops with [PendingReservationsFilters] on Apply or Reset.
class PendingReservationsFilterScreen extends StatefulWidget {
  const PendingReservationsFilterScreen({super.key, this.initialFilters});

  final PendingReservationsFilters? initialFilters;

  @override
  State<PendingReservationsFilterScreen> createState() =>
      _PendingReservationsFilterScreenState();
}

class _PendingReservationsFilterScreenState
    extends State<PendingReservationsFilterScreen> {
  late final TextEditingController _codeController;
  String? _regionId;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _codeController = TextEditingController(text: f?.reservationNumber ?? '');
    _regionId = f?.regionId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRegions());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _loadRegions() {
    if (!mounted) return;
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      context.read<RegionsProvider>().load(venueId);
    }
  }

  PendingReservationsFilters get _currentFilters => PendingReservationsFilters(
    reservationNumber: _codeController.text.trim().isEmpty
        ? null
        : _codeController.text.trim(),
    regionId: _regionId,
  );

  void _close() {
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    Navigator.of(context).pop(PendingReservationsFilters());
  }

  void _apply() {
    Navigator.of(context).pop(_currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final regions = context.watch<RegionsProvider>().regions;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _close,
        ),
        title: Text(l10n.filterTitle),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackground,
        foregroundColor: AppColors.appBarForeground,
        elevation: 0,
      ),
      body: ConstrainedContent(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ReservationCodeRegionFilterFields(
                      codeController: _codeController,
                      selectedRegionId: _regionId,
                      regions: regions,
                      onRegionSelected: (regionId) {
                        setState(() => _regionId = regionId);
                      },
                    ),
                  ),
                ),
              ),
            ),
            FilterScreenFooter(
              layout: FilterFooterLayout.column,
              secondaryLabel: l10n.filterReset,
              primaryLabel: l10n.filterApply,
              onSecondary: _resetFilters,
              onPrimary: _apply,
            ),
          ],
        ),
      ),
    );
  }
}
