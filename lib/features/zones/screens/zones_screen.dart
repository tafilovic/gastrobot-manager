import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/list_item_entrance.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_model.dart';
import 'package:gastrobotmanager/features/zones/providers/zones_provider.dart';
import 'package:gastrobotmanager/features/zones/utils/group_zones_by_display_category.dart';
import 'package:gastrobotmanager/features/zones/utils/zone_type_display.dart';
import 'package:gastrobotmanager/features/zones/widgets/zone_list_item.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Zones overview screen — lists all venue seating zones with their status.
class ZonesScreen extends StatefulWidget {
  const ZonesScreen({super.key});

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends State<ZonesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      context.read<ZonesProvider>().load(venueId);
    }
  }

  void _onZoneCardTapped(ZoneModel zone) {
    context.pushNamed(
      AppRouteNames.zoneOverview,
      extra: zone,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final provider = context.watch<ZonesProvider>();
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                l10n.navZones,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Builder(
                builder: (context) {
                  final count = provider.zones.length;
                  final full = l10n.zonesCount(count);
                  final suffix = full.replaceFirst(RegExp(r'^\d+'), '');
                  return Text.rich(
                    TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: '$count',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: suffix),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: _ZonesGroupedList(
                provider: provider,
                l10n: l10n,
                onZoneTap: _onZoneCardTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Zones list with collapsible category sections (room / sunbed / table).
class _ZonesGroupedList extends StatefulWidget {
  const _ZonesGroupedList({
    required this.provider,
    required this.l10n,
    required this.onZoneTap,
  });

  final ZonesProvider provider;
  final AppLocalizations l10n;
  final void Function(ZoneModel zone) onZoneTap;

  @override
  State<_ZonesGroupedList> createState() => _ZonesGroupedListState();
}

class _ZonesGroupedListState extends State<_ZonesGroupedList> {
  /// Categories the user has collapsed; absent entries are expanded.
  final Set<ZoneDisplayCategory> _collapsed = {};

  void _toggleCategory(ZoneDisplayCategory category) {
    setState(() {
      if (_collapsed.contains(category)) {
        _collapsed.remove(category);
      } else {
        _collapsed.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final l10n = widget.l10n;

    if (provider.isLoading && provider.zones.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.zones.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final zones = provider.zones;
    final grouped = groupZonesByDisplayCategory(zones);

    if (zones.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.pullRefresh,
        color: AppColors.accent,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              child: Center(
                child: Text(
                  l10n.acceptSheetNoTables,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, _) {
        final width = MediaQuery.sizeOf(context).width;
        final crossAxisCount = width >= AppBreakpoints.contentMaxWidthWide
            ? 3
            : width >= AppBreakpoints.expanded
            ? 2
            : 1;
        final maxWidth = crossAxisCount > 1
            ? AppBreakpoints.contentMaxWidthWide
            : AppBreakpoints.contentMaxWidth;

        return ConstrainedContent(
          maxWidth: maxWidth,
          padding: EdgeInsets.zero,
          child: RefreshIndicator(
            onRefresh: provider.pullRefresh,
            color: AppColors.accent,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: _buildGroupedZoneSlivers(
                grouped: grouped,
                l10n: l10n,
                crossAxisCount: crossAxisCount,
                onZoneTap: widget.onZoneTap,
                collapsed: _collapsed,
                onToggleCategory: _toggleCategory,
              ),
            ),
          ),
        );
      },
    );
  }
}

String _zoneCategorySectionLabel(
  ZoneDisplayCategory category,
  AppLocalizations l10n,
) {
  return switch (category) {
    ZoneDisplayCategory.room => l10n.tableTypeRoom,
    ZoneDisplayCategory.sunbed => l10n.tableTypeSunbed,
    ZoneDisplayCategory.table => l10n.tableTypeTable,
  };
}

List<Widget> _buildGroupedZoneSlivers({
  required List<({ZoneDisplayCategory category, List<ZoneModel> zones})>
      grouped,
  required AppLocalizations l10n,
  required int crossAxisCount,
  required void Function(ZoneModel zone) onZoneTap,
  required Set<ZoneDisplayCategory> collapsed,
  required void Function(ZoneDisplayCategory category) onToggleCategory,
}) {
  final slivers = <Widget>[];
  var entranceIndex = 0;

  for (var s = 0; s < grouped.length; s++) {
    final section = grouped[s];
    final isFirst = s == 0;
    final label = _zoneCategorySectionLabel(section.category, l10n);
    final expanded = !collapsed.contains(section.category);
    final count = section.zones.length;

    slivers.add(
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, isFirst ? 4 : 16, 12, expanded ? 8 : 4),
          child: Material(
            color: Colors.transparent,
            child: Semantics(
              button: true,
              expanded: expanded,
              label: '$label ($count)',
              child: InkWell(
                onTap: () => onToggleCategory(section.category),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        expanded ? Icons.expand_more : Icons.chevron_right,
                        size: 22,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        zoneDisplayCategoryIcon(section.category),
                        size: 22,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!expanded) {
      continue;
    }

    if (crossAxisCount == 1) {
      final n = section.zones.length;
      final childCount = n == 0 ? 0 : (n * 2 - 1);
      final start = entranceIndex;
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) {
                  return const SizedBox(height: 12);
                }
                final zoneIndex = index ~/ 2;
                final zone = section.zones[zoneIndex];
                return ListItemEntrance(
                  index: start + zoneIndex,
                  child: ZoneListItem(
                    zone: zone,
                    onTap: () => onZoneTap(zone),
                  ),
                );
              },
              childCount: childCount,
            ),
          ),
        ),
      );
    } else {
      final zones = section.zones;
      final rowCount =
          (zones.length + crossAxisCount - 1) ~/ crossAxisCount;
      final gridChildCount = rowCount == 0 ? 0 : (rowCount * 2 - 1);
      final start = entranceIndex;
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index.isOdd) {
                  return const SizedBox(height: 12);
                }
                final rowIndex = index ~/ 2;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var col = 0; col < crossAxisCount; col++) ...[
                      if (col > 0) const SizedBox(width: 12),
                      Expanded(
                        child: _ZoneSectionGridCell(
                          rowIndex: rowIndex,
                          col: col,
                          crossAxisCount: crossAxisCount,
                          zones: zones,
                          entranceBase: start,
                          onZoneTap: onZoneTap,
                        ),
                      ),
                    ],
                  ],
                );
              },
              childCount: gridChildCount,
            ),
          ),
        ),
      );
    }

    entranceIndex += section.zones.length;
  }

  slivers.add(
    const SliverPadding(padding: EdgeInsets.only(bottom: 8)),
  );

  return slivers;
}

class _ZoneSectionGridCell extends StatelessWidget {
  const _ZoneSectionGridCell({
    required this.rowIndex,
    required this.col,
    required this.crossAxisCount,
    required this.zones,
    required this.entranceBase,
    required this.onZoneTap,
  });

  final int rowIndex;
  final int col;
  final int crossAxisCount;
  final List<ZoneModel> zones;
  final int entranceBase;
  final void Function(ZoneModel zone) onZoneTap;

  @override
  Widget build(BuildContext context) {
    final index = rowIndex * crossAxisCount + col;
    if (index >= zones.length) {
      return const SizedBox.shrink();
    }
    final zone = zones[index];
    return ListItemEntrance(
      index: entranceBase + index,
      child: ZoneListItem(
        zone: zone,
        onTap: () => onZoneTap(zone),
      ),
    );
  }
}
