import 'package:flutter/material.dart';

import '../../../core/models/user.dart';
import '../../../core/theme/app_colors.dart';
import '../utils/profile_image_url.dart';
import 'profile_avatar.dart';

/// Profile header: avatar with edit button, name, email.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEditPhoto,
  });

  final User user;
  final VoidCallback onEditPhoto;

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
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
