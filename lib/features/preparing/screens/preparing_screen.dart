import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/preparing/providers/queue_provider.dart';
import 'package:gastrobotmanager/features/preparing/widgets/preparing_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Preparing screen: for chef (and bar) shows kitchen queue (prepStatus=ready) in card layout with "Mark as ready".
/// For waiter shows placeholder.
class PreparingScreen extends StatelessWidget {
  const PreparingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;

    if (profileType != ProfileType.kitchen && profileType != ProfileType.bar) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.preparingTitle),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pending_actions,
                size: 64,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.preparingTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.preparingSubtitle,
                style: const TextStyle(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final accentColor = theme.colorScheme.primary;
    return PreparingContent(
      accentColor: accentColor,
      onStartRefresh: () {
        final venueId = auth.currentVenueId;
        if (venueId != null) {
          context.read<QueueProvider>().startPeriodicRefresh(venueId);
        }
      },
    );
  }
}
