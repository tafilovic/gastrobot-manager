import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Single profile settings row: icon, label, optional value or trailing.
class ProfileRow extends StatelessWidget {
  const ProfileRow({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent, size: 24),
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
                    color: valueColor ?? AppColors.textPrimary,
                    fontWeight: valueColor != null ? FontWeight.w500 : null,
                  ),
                )
              : null),
    );
  }
}
