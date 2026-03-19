import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gastrobotmanager/core/navigation/nav_item.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Side rail for tablet/desktop. Same destinations as [AppBottomNav].
class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
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

  Widget _buildIcon(NavItem item, bool isSelected) {
    final color = isSelected ? AppColors.accent : AppColors.textMuted;
    if (item.svgAssetPath != null) {
      return SvgPicture.asset(
        item.svgAssetPath!,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }
    return Icon(item.icon!, size: 24, color: color);
  }

  static const double _compactHeightThreshold = 500;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final isCompactHeight = height < _compactHeightThreshold;
    final labelType = isCompactHeight
        ? NavigationRailLabelType.selected
        : NavigationRailLabelType.all;

    return Container(
      color: AppColors.surface,
      child: NavigationRail(
        backgroundColor: AppColors.surface,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: labelType,
        leading: SizedBox(height: isCompactHeight ? 8 : 24),
        trailing: const Spacer(),
        destinations: [
          for (int i = 0; i < items.length; i++)
            NavigationRailDestination(
              icon: _buildIcon(items[i], false),
              selectedIcon: _buildIcon(items[i], true),
              label: Text(_label(i)),
            ),
        ],
      ),
    );
  }
}
