import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Tappable card with list-style selection: outer [BoxDecoration.boxShadow] (like [Container])
/// plus [Ink] face without shadow so elevation matches selected order / history cards.
class SelectableInkCard extends StatelessWidget {
  const SelectableInkCard({
    super.key,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.borderRadius = 12,
  });

  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final double borderRadius;

  static List<BoxShadow> _shadows({
    required bool isSelected,
    required Color accentColor,
  }) {
    if (isSelected) {
      return [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.28),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static BoxDecoration _faceDecoration({
    required bool isSelected,
    required Color accentColor,
    required double radius,
  }) {
    if (isSelected) {
      return BoxDecoration(
        color: Color.alphaBlend(
          accentColor.withValues(alpha: 0.12),
          AppColors.surface,
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: accentColor, width: 2),
      );
    }
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = borderRadius;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        boxShadow: _shadows(isSelected: isSelected, accentColor: accentColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(r),
            child: Ink(
              decoration: _faceDecoration(
                isSelected: isSelected,
                accentColor: accentColor,
                radius: r,
              ),
              child: SizedBox(
                width: double.infinity,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
