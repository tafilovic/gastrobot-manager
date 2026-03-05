import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';

/// Single menu item row: thumbnail, name, availability switch.
class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.accentColor,
    required this.onAvailabilityChanged,
  });

  final MenuItem item;
  final Color accentColor;
  final ValueChanged<bool> onAvailabilityChanged;

  static String? _resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://devapirestobot.brrm.eu$url';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = _resolveImageUrl(item.product.imageUrl);
    final isDisabled = !item.isAvailable;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(theme),
                      )
                    : _placeholder(theme),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.product.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Theme(
                data: Theme.of(context).copyWith(
                  switchTheme: SwitchThemeData(
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return accentColor;
                      }
                      return AppColors.border;
                    }),
                    thumbColor: const WidgetStatePropertyAll(Colors.white),
                  ),
                ),
                child: Switch(
                  value: item.isAvailable,
                  onChanged: (v) => onAvailabilityChanged(v),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      color: AppColors.backgroundMuted,
      child: Icon(Icons.restaurant, color: AppColors.textMuted, size: 28),
    );
  }
}
