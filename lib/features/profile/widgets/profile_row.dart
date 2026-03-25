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
    this.onTap,
    this.leading,
    this.labelStyle,
  });

  final IconData icon;
  final String label;

  /// When set, replaces the default [Icon] built from [icon].
  final Widget? leading;

  /// Overrides default title [TextStyle] for [label].
  final TextStyle? labelStyle;
  final String? value;
  final Color? valueColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading ??
          Icon(icon, color: AppColors.accent, size: 24),
      title: Text(
        label,
        style: labelStyle ??
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.accent,
            ),
      ),
      trailing: trailing ??
          (value != null
              ? Text(
                  value!,
                  style: TextStyle(
                    color: valueColor ?? AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null),
    );
  }
}
