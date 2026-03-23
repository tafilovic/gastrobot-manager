import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/list_item_entrance.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/utils/group_tables_by_display_category.dart';
import 'package:gastrobotmanager/features/tables/utils/table_type_display.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_list_item.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Tables overview screen — lists all venue tables with their status.
class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    if (!mounted) return;
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      context.read<TablesProvider>().load(venueId);
    }
  }

  void _onTableCardTapped(TableModel table) {
    context.pushNamed(
      AppRouteNames.tableOverview,
      extra: table,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final provider = context.watch<TablesProvider>();
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
                l10n.navTables,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.contentMaxWidth,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.pushNamed(AppRouteNames.tableOrder);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(l10n.tablesOrder),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Builder(
                builder: (context) {
                  final count = provider.tables.length;
                  final full = l10n.tablesCount(count);
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
              child: _TablesGroupedList(
                provider: provider,
                l10n: l10n,
                onTableTap: _onTableCardTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tables list with collapsible category sections (room / sunbed / table).
class _TablesGroupedList extends StatefulWidget {
  const _TablesGroupedList({
    required this.provider,
    required this.l10n,
    required this.onTableTap,
  });

  final TablesProvider provider;
  final AppLocalizations l10n;
  final void Function(TableModel table) onTableTap;

  @override
  State<_TablesGroupedList> createState() => _TablesGroupedListState();
}

class _TablesGroupedListState extends State<_TablesGroupedList> {
  /// Categories the user has collapsed; absent entries are expanded.
  final Set<TableDisplayCategory> _collapsed = {};

  void _toggleCategory(TableDisplayCategory category) {
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

    if (provider.isLoading && provider.tables.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.tables.isEmpty) {
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

    final tables = provider.tables;
    final grouped = groupTablesByDisplayCategory(tables);

    if (tables.isEmpty) {
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
                  l10n.tablesCount(0),
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
              slivers: _buildGroupedTableSlivers(
                grouped: grouped,
                l10n: l10n,
                crossAxisCount: crossAxisCount,
                onTableTap: widget.onTableTap,
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

String _tableCategorySectionLabel(
  TableDisplayCategory category,
  AppLocalizations l10n,
) {
  return switch (category) {
    TableDisplayCategory.room => l10n.tableTypeRoom,
    TableDisplayCategory.sunbed => l10n.tableTypeSunbed,
    TableDisplayCategory.table => l10n.tableTypeTable,
  };
}

List<Widget> _buildGroupedTableSlivers({
  required List<({TableDisplayCategory category, List<TableModel> tables})>
      grouped,
  required AppLocalizations l10n,
  required int crossAxisCount,
  required void Function(TableModel table) onTableTap,
  required Set<TableDisplayCategory> collapsed,
  required void Function(TableDisplayCategory category) onToggleCategory,
}) {
  final slivers = <Widget>[];
  var entranceIndex = 0;

  for (var s = 0; s < grouped.length; s++) {
    final section = grouped[s];
    final isFirst = s == 0;
    final label = _tableCategorySectionLabel(section.category, l10n);
    final expanded = !collapsed.contains(section.category);
    final count = section.tables.length;

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
                        tableDisplayCategoryIcon(section.category),
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
      final n = section.tables.length;
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
                final tableIndex = index ~/ 2;
                final table = section.tables[tableIndex];
                return ListItemEntrance(
                  index: start + tableIndex,
                  child: TableListItem(
                    table: table,
                    onTap: () => onTableTap(table),
                  ),
                );
              },
              childCount: childCount,
            ),
          ),
        ),
      );
    } else {
      final tables = section.tables;
      final rowCount =
          (tables.length + crossAxisCount - 1) ~/ crossAxisCount;
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
                        child: _TableSectionGridCell(
                          rowIndex: rowIndex,
                          col: col,
                          crossAxisCount: crossAxisCount,
                          tables: tables,
                          entranceBase: start,
                          onTableTap: onTableTap,
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

    entranceIndex += section.tables.length;
  }

  slivers.add(
    const SliverPadding(padding: EdgeInsets.only(bottom: 8)),
  );

  return slivers;
}

class _TableSectionGridCell extends StatelessWidget {
  const _TableSectionGridCell({
    required this.rowIndex,
    required this.col,
    required this.crossAxisCount,
    required this.tables,
    required this.entranceBase,
    required this.onTableTap,
  });

  final int rowIndex;
  final int col;
  final int crossAxisCount;
  final List<TableModel> tables;
  final int entranceBase;
  final void Function(TableModel table) onTableTap;

  @override
  Widget build(BuildContext context) {
    final index = rowIndex * crossAxisCount + col;
    if (index >= tables.length) {
      return const SizedBox.shrink();
    }
    final table = tables[index];
    return ListItemEntrance(
      index: entranceBase + index,
      child: TableListItem(
        table: table,
        onTap: () => onTableTap(table),
      ),
    );
  }
}
