import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/image_loader.dart';

/// User avatar: network image or placeholder icon.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.imageUrl});

  final String? imageUrl;

  static Widget _personPlaceholder() =>
      const Icon(Icons.person, size: 56, color: AppColors.onPrimary);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: 48,
        backgroundColor: AppColors.accent,
        child: _personPlaceholder(),
      );
    }
    return CircleAvatar(
      radius: 48,
      backgroundColor: AppColors.accent,
      child: ClipOval(
        child: ImageLoader(
          imageUrl: imageUrl!,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
          placeholder: _personPlaceholder(),
          errorWidget: _personPlaceholder(),
        ),
      ),
    );
  }
}
