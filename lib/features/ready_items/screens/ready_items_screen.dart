import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/ready_items/providers/ready_items_provider.dart';
import 'package:gastrobotmanager/features/ready_items/widgets/ready_items_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Ready-for-serving screen for waiter: list of ready orders with "Mark as served".
/// For non-waiter roles shows a placeholder.
class ReadyItemsScreen extends StatelessWidget {
  const ReadyItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;

    if (profileType != ProfileType.waiter) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.readyTitle),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.done_all,
                size: 64,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.readyTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.readySubtitle,
                style: const TextStyle(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final accentColor = theme.colorScheme.primary;
    return ReadyItemsContent(
      accentColor: accentColor,
      onStartRefresh: () {
        final venueId = auth.currentVenueId;
        if (venueId != null) {
          context.read<ReadyItemsProvider>().loadOnce(venueId);
        }
      },
    );
  }
}
