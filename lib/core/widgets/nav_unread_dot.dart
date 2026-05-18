import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Small unread indicator for bottom nav / rail icons.
class NavUnreadDot extends StatelessWidget {
  const NavUnreadDot({super.key});

  static const double size = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.unreadIndicator,
        shape: BoxShape.circle,
      ),
    );
  }
}
