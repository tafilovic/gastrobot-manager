import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/profile_type.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/menu_provider.dart';
import '../widgets/menu_item_card.dart';

/// Menu screen: for chef (food) and bartender (drinks) shows list with search and toggles.
/// For waiter shows placeholder.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;

    if (profileType != ProfileType.kitchen && profileType != ProfileType.bar) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.menuTitle),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book, size: 64, color: AppColors.textMuted),
              const SizedBox(height: 16),
              Text(
                l10n.menuTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.menuSubtitle,
                style: const TextStyle(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final menuType =
        profileType == ProfileType.kitchen ? 'food' : 'drinks';
    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      body: SafeArea(
        child: _MenuContent(
          menuType: menuType,
          searchQuery: _searchQuery,
          searchController: _searchController,
          accentColor: accentColor,
        ),
      ),
    );
  }
}

class _MenuContent extends StatefulWidget {
  const _MenuContent({
    required this.menuType,
    required this.searchQuery,
    required this.searchController,
    required this.accentColor,
  });

  final String menuType;
  final String searchQuery;
  final TextEditingController searchController;
  final Color accentColor;

  @override
  State<_MenuContent> createState() => _MenuContentState();
}

class _MenuContentState extends State<_MenuContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMenu());
  }

  void _loadMenu() {
    final auth = context.read<AuthProvider>();
    final venueId = auth.user?.venueUsers.isNotEmpty == true
        ? auth.user!.venueUsers.first.venueId
        : null;
    if (venueId != null) {
      context.read<MenuProvider>().load(venueId, widget.menuType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final provider = context.watch<MenuProvider>();

    if (provider.loading && provider.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            provider.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      );
    }

    final filtered = provider.items.where((i) {
      if (widget.searchQuery.isEmpty) return true;
      return i.product.name.toLowerCase().contains(widget.searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            l10n.menuTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            l10n.menuInstruction,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: '${provider.availableCount}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: l10n.menuAvailableCountMiddle),
                TextSpan(
                  text: '${provider.totalCount}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              hintText: l10n.menuSearchHint,
              hintStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = filtered[index];
              return MenuItemCard(
                item: item,
                accentColor: widget.accentColor,
                onAvailabilityChanged: (_) async {
                  final ok = await provider.toggleAvailability(item.id);
                  if (!context.mounted) return;
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.error ?? ''),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
