import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/list_item_entrance.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_list_item.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
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
              child: _TablesList(provider: provider, l10n: l10n),
            ),
          ],
        ),
      ),
    );
  }
}

class _TablesList extends StatelessWidget {
  const _TablesList({required this.provider, required this.l10n});

  final TablesProvider provider;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
      builder: (context, constraints) {
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
            child: crossAxisCount == 1
                ? ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: tables.length,
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      return ListItemEntrance(
                        index: index,
                        child: TableListItem(
                          table: table,
                          onTap: () => context.pushNamed(
                            AppRouteNames.tableOverview,
                            extra: table,
                          ),
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 80,
                    ),
                    itemCount: tables.length,
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      return ListItemEntrance(
                        index: index,
                        child: TableListItem(
                          table: table,
                          onTap: () => context.pushNamed(
                            AppRouteNames.tableOverview,
                            extra: table,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
