import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Circular leading tile with a currency glyph (used in [CurrencySelectionDialog]).
class CurrencyListSymbolLeading extends StatelessWidget {
  const CurrencyListSymbolLeading({
    super.key,
    required this.symbol,
    required this.isSelected,
  });

  final String symbol;
  final bool isSelected;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.14)
              : AppColors.backgroundMuted,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                symbol,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: isSelected ? AppColors.accent : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
