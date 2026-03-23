import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/currency_provider.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/currency/supported_currencies.dart';
import 'package:gastrobotmanager/features/profile/widgets/currency_list_symbol_leading.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Dialog to pick how amounts are labeled/formatted (no FX conversion; numeric value unchanged).
class CurrencySelectionDialog extends StatelessWidget {
  const CurrencySelectionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => const CurrencySelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currency = context.watch<CurrencyProvider>();
    final colorScheme = Theme.of(context).colorScheme;

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
                  l10n.profileCurrencyDialogTitle,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      (MediaQuery.sizeOf(context).height * 0.65).clamp(200, 520),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: kSupportedCurrencies.map((option) {
                      final isSelected = currency.selected.id == option.id;
                      return ListTile(
                        leading: CurrencyListSymbolLeading(
                          symbol: option.symbol,
                          isSelected: isSelected,
                        ),
                        title: Text(option.displayName),
                        subtitle: Text(
                          option.code,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: AppColors.accent, size: 24)
                            : null,
                        onTap: () {
                          currency.setCurrency(option);
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
