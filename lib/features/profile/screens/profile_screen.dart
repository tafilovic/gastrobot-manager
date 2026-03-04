import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_row.dart';
import '../widgets/profile_row_with_subtitle.dart';
import 'profile_image_dialog.dart';

/// Profile screen: header with avatar, user details, settings rows, logout with confirmation.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<ProfileProvider>();
    final user = profile.user!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackground,
        foregroundColor: AppColors.appBarForeground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              user: user,
              onEditPhoto: () => ProfileImageDialog.show(context, user),
            ),
            const Divider(height: 1),
            ProfileRow(
              icon: Icons.person_outline,
              label: l10n.profileLabelName,
              value: user.name,
              valueColor: AppColors.accent,
            ),
            const Divider(height: 1, indent: 56),
            ProfileRow(
              icon: Icons.email_outlined,
              label: l10n.profileLabelEmail,
              value: user.email,
            ),
            const Divider(height: 1, indent: 56),
            ProfileRow(
              icon: Icons.lock_outline,
              label: l10n.profileLabelPassword,
              trailing: TextButton(
                onPressed: () {
                  // TODO: change password flow
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(l10n.profileChangePassword),
              ),
            ),
            const Divider(height: 1, indent: 56),
            ProfileRowWithSubtitle(
              icon: Icons.notifications_outlined,
              label: l10n.profileReservationReminder,
              subtitle: l10n.profileReservationReminderHint,
              value: l10n.profileReservationReminderValue,
              trailing: Icon(Icons.more_horiz, color: AppColors.textMuted, size: 20),
            ),
            const Divider(height: 1, indent: 56),
            ProfileRow(
              icon: Icons.language,
              label: l10n.profileLabelLanguage,
              value: l10n.profileLanguageValue,
              valueColor: AppColors.accent,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _showLogoutDialog(context, profile),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.destructive,
                    foregroundColor: AppColors.onDestructive,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l10n.profileLogout),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileProvider profile) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutDialogTitle),
        content: Text(l10n.logoutDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.logoutCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.destructive),
            child: Text(l10n.logoutConfirm),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        profile.logout();
      }
    });
  }
}
