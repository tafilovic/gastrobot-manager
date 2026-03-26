import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/profile/providers/profile_provider.dart';
import 'package:gastrobotmanager/features/profile/widgets/profile_header.dart';
import 'package:gastrobotmanager/features/profile/widgets/profile_row.dart';
import 'package:gastrobotmanager/features/profile/widgets/profile_row_with_subtitle.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';
import 'package:gastrobotmanager/features/profile/screens/profile_image_dialog.dart';
import 'package:gastrobotmanager/features/profile/widgets/language_selection_dialog.dart';
import 'package:gastrobotmanager/core/l10n/locale_provider.dart';
import 'package:gastrobotmanager/features/staff_schedules/widgets/shift_schedule_dialog.dart';

/// Profile screen: header with avatar, user details, settings rows, logout with confirmation.
/// Loads fresh user data when the screen is opened.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().refreshUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<ProfileProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final auth = context.watch<AuthProvider>();
    final user = profile.user!;
    final isWaiter = auth.profileType == ProfileType.waiter;

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
        child: ConstrainedContent(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
            if (auth.currentVenueId != null) ...[
              ProfileRow(
                icon: Icons.calendar_today,
                label: l10n.profileShiftScheduleLabel,
                leading: shiftScheduleProfileLeadingIcon(),
                onTap: () => showShiftScheduleDialog(context),
                trailing: TextButton(
                  onPressed: () => showShiftScheduleDialog(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    l10n.profileShiftScheduleView,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, indent: 56),
            ],
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
              value: localeProvider.currentLocaleName,
              onTap: () => LanguageSelectionDialog.show(context),
            ),
            const Divider(height: 1, indent: 56),
            ProfileRow(
              icon: Icons.delete_outline,
              leading: const Icon(
                Icons.delete_outline,
                color: AppColors.destructive,
                size: 24,
              ),
              label: l10n.profileDeleteAccount,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.destructive,
              ),
              value: l10n.profileDeleteAccountAction,
              valueColor: AppColors.destructive,
              onTap: () => _showDeleteAccountDialog(context, profile),
            ),
            const SizedBox(height: 32),
            if (isWaiter)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.pushNamed(AppRouteNames.drinks),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: BorderSide(color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.local_bar),
                    label: Text(l10n.profileDrinksList),
                  ),
                ),
              ),
            if (isWaiter) const SizedBox(height: 12),
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

  void _showDeleteAccountDialog(BuildContext context, ProfileProvider profile) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileDeleteAccount),
        content: Text(
          l10n.profileDeleteAccountWarning,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.dialogNo),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.destructive),
            child: Text(l10n.dialogYes),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed != true || !mounted) return;
      await _simulateDeleteAccountCallAndLogout(profile);
    });
  }

  Future<void> _simulateDeleteAccountCallAndLogout(ProfileProvider profile) async {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // TODO(stefan): Replace with real delete-account endpoint call.
      await Future<void>.delayed(const Duration(seconds: 1));
      await profile.logout();
      if (!mounted) return;
      context.go(AppRouteNames.pathLogin);
    } finally {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

}
