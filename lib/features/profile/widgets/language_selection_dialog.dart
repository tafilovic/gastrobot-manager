import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_flags/world_flags.dart';

import 'package:gastrobotmanager/core/l10n/locale_provider.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Dialog to select application language. Shows flag and name for each option.
class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return const LanguageSelectionDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final sortedLocales = [...supportedLocales]..sort(
          (a, b) =>
              a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );

    const radius = 28.0;
    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(radius),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  l10n.profileLabelLanguage,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (MediaQuery.of(context).size.height * 0.8)
                    .clamp(200, double.infinity),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sortedLocales.map((supported) {
                    final isSelected =
                        localeProvider.locale?.languageCode ==
                            supported.locale.languageCode;
                    return ListTile(
                      leading: SizedBox(
                        width: 40,
                        height: 28,
                        child: CountryFlag.simplified(
                          supported.country,
                          height: 28,
                        ),
                      ),
                      title: Text(supported.name),
                      subtitle: Text(
                        supported.locale.languageCode.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: AppColors.accent, size: 24)
                          : null,
                      onTap: () {
                        localeProvider.setLocale(supported.locale);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
