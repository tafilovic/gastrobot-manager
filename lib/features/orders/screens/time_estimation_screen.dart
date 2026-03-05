import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/models/kitchen_pending_order.dart';
import '../domain/repositories/order_items_api.dart';

/// Minutes available in the time picker (format "00 : MM").
const List<int> _minuteOptions = [5, 10, 15, 20, 25, 30, 45, 60];

/// Screen to choose estimated prep time for accepted items.
/// [checkedItemIds] = items to accept (with or without time); the rest are rejected.
class TimeEstimationScreen extends StatefulWidget {
  const TimeEstimationScreen({
    super.key,
    required this.order,
    required this.checkedItemIds,
  });

  final KitchenPendingOrder order;
  final Set<String> checkedItemIds;

  @override
  State<TimeEstimationScreen> createState() => _TimeEstimationScreenState();
}

class _TimeEstimationScreenState extends State<TimeEstimationScreen> {
  late FixedExtentScrollController _pickerController;
  int _selectedMinutes = 20;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final initialIndex = _minuteOptions.indexOf(_selectedMinutes);
    _pickerController = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _pickerController.dispose();
    super.dispose();
  }

  String get _venueId {
    final user = context.read<AuthProvider>().user;
    if (user?.venueUsers.isEmpty ?? true) return '';
    return user!.venueUsers.first.venueId;
  }

  /// Reject all items not in [widget.checkedItemIds]; accept items in
  /// [widget.checkedItemIds] with optional [estimatedPrepTimeMinutes].
  Future<bool> _submit({int? estimatedPrepTimeMinutes}) async {
    final venueId = _venueId;
    if (venueId.isEmpty) return false;

    final api = context.read<OrderItemsApi>();
    final orderId = widget.order.orderId;
    final allIds = {for (final i in widget.order.items) i.id};
    final toReject = allIds.difference(widget.checkedItemIds).toList();
    final toAccept = widget.checkedItemIds.toList();

    setState(() => _isLoading = true);

    try {
      for (final itemId in toReject) {
        await api.rejectOrderItem(venueId, orderId, itemId);
      }
      for (final itemId in toAccept) {
        await api.acceptOrderItem(
          venueId,
          orderId,
          itemId,
          estimatedPrepTimeMinutes: estimatedPrepTimeMinutes,
        );
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onSkip() async {
    if (_isLoading) return;
    final ok = await _submit();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.authInvalidResponse),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _onConfirm() async {
    if (_isLoading) return;
    final ok = await _submit(estimatedPrepTimeMinutes: _selectedMinutes);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.authInvalidResponse),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(
        title: Text(l10n.timeEstimationTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                l10n.timeEstimationTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Text(
                l10n.timeEstimationQuestion,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: ListWheelScrollView.useDelegate(
                controller: _pickerController,
                itemExtent: 52,
                diameterRatio: 1.2,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedMinutes = _minuteOptions[index];
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _minuteOptions.length,
                  builder: (context, index) {
                    final minutes = _minuteOptions[index];
                    final isSelected = minutes == _selectedMinutes;
                    return Center(
                      child: Text(
                        '00 : ${minutes.toString().padLeft(2, '0')}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isSelected ? accentColor : AppColors.textMuted,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: isSelected ? 22 : 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: _isLoading ? null : _onSkip,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accentColor,
                      side: BorderSide(color: accentColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(l10n.timeEstimationSkip),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _isLoading ? null : _onConfirm,
                    style: FilledButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.timeEstimationConfirm),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
