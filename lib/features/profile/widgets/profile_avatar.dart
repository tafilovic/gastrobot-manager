import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// User avatar: network image or placeholder icon.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: 48,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.person, size: 56, color: AppColors.onPrimary),
      );
    }
    return CircleAvatar(
      radius: 48,
      backgroundColor: AppColors.accent,
      child: ClipOval(
        child: Image.network(
          imageUrl!,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 56, color: AppColors.onPrimary),
        ),
      ),
    );
  }
}
