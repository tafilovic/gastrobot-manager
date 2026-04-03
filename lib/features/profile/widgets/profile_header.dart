import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/profile/utils/profile_image_url.dart';
import 'package:gastrobotmanager/features/profile/widgets/profile_avatar.dart';

/// Profile header: avatar with edit button, name, email, optional app [versionName].
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEditPhoto,
    this.versionName,
  });

  final User user;
  final VoidCallback onEditPhoto;

  /// User-facing app version (e.g. Android `versionName`); shown under [user.email].
  final String? versionName;

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
              ProfileAvatar(imageUrl: imageUrl),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onEditPhoto,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.accent,
                    child: const Icon(Icons.edit, size: 16, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          if (versionName != null && versionName!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              versionName!,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.5),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
