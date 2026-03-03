import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../utils/profile_image_url.dart';
import 'profile_image_dialog.dart';

/// Profile screen: header with avatar, user details, settings rows, logout with confirmation.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _accentBlue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final user = auth.user!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(
              user: user,
              onEditPhoto: () => ProfileImageDialog.show(context, user),
            ),
            const Divider(height: 1),
            _ProfileRow(
              icon: Icons.person_outline,
              label: l10n.profileLabelName,
              value: user.name,
              valueColor: _accentBlue,
            ),
            const Divider(height: 1, indent: 56),
            _ProfileRow(
              icon: Icons.email_outlined,
              label: l10n.profileLabelEmail,
              value: user.email,
            ),
            const Divider(height: 1, indent: 56),
            _ProfileRow(
              icon: Icons.lock_outline,
              label: l10n.profileLabelPassword,
              trailing: TextButton(
                onPressed: () {
                  // TODO: change password flow
                },
                style: TextButton.styleFrom(
                  foregroundColor: _accentBlue,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(l10n.profileChangePassword),
              ),
            ),
            const Divider(height: 1, indent: 56),
            _ProfileRowWithSubtitle(
              icon: Icons.notifications_outlined,
              label: l10n.profileReservationReminder,
              subtitle: l10n.profileReservationReminderHint,
              value: l10n.profileReservationReminderValue,
              trailing: Icon(Icons.more_horiz, color: Colors.grey[600], size: 20),
            ),
            const Divider(height: 1, indent: 56),
            _ProfileRow(
              icon: Icons.language,
              label: l10n.profileLabelLanguage,
              value: l10n.profileLanguageValue,
              valueColor: _accentBlue,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _showLogoutDialog(context, auth),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
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

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
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
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.logoutConfirm),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        auth.logout();
      }
    });
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.onEditPhoto});

  final User user;
  final VoidCallback onEditPhoto;

  static const _accentBlue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    final imageUrl = resolveProfileImageUrl(user.profileImageUrl);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _ProfileAvatar(imageUrl: imageUrl, accentBlue: _accentBlue),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onEditPhoto,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: _accentBlue,
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.imageUrl, required this.accentBlue});

  final String? imageUrl;
  final Color accentBlue;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: 48,
        backgroundColor: accentBlue,
        child: const Icon(Icons.person, size: 56, color: Colors.white),
      );
    }
    return CircleAvatar(
      radius: 48,
      backgroundColor: accentBlue,
      child: ClipOval(
        child: Image.network(
          imageUrl!,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 56, color: Colors.white),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    this.value,
    this.valueColor,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Color? valueColor;
  final Widget? trailing;

  static const _accentBlue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: _accentBlue, size: 24),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      trailing: trailing ??
          (value != null
              ? Text(
                  value!,
                  style: TextStyle(
                    color: valueColor ?? Colors.black87,
                    fontWeight: valueColor != null ? FontWeight.w500 : null,
                  ),
                )
              : null),
    );
  }
}

class _ProfileRowWithSubtitle extends StatelessWidget {
  const _ProfileRowWithSubtitle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final String value;
  final Widget? trailing;

  static const _accentBlue = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: _accentBlue, size: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.black87)),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
