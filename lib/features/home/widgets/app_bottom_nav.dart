import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/navigation/nav_item.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Custom bottom nav with labels limited to 1 line.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    this.labels,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<NavItem> items;
  /// Optional display labels (e.g. localized). If null, uses [NavItem.label].
  final List<String>? labels;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  String _label(int index) {
    if (labels != null && index < labels!.length) return labels![index];
    return items[index].label;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == selectedIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onDestinationSelected(index),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 24,
                          color: isSelected ? AppColors.accent : AppColors.textMuted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _label(index),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? AppColors.accent : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
