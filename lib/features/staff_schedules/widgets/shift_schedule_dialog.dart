import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/staff_schedules/domain/errors/staff_schedules_exception.dart';
import 'package:gastrobotmanager/features/staff_schedules/domain/models/staff_member_schedule.dart';
import 'package:gastrobotmanager/features/staff_schedules/domain/repositories/staff_schedules_api.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Profile row leading: calendar with small clock (per design).
Widget shiftScheduleProfileLeadingIcon() {
  return SizedBox(
    width: 28,
    height: 24,
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Icon(Icons.calendar_today, color: AppColors.accent, size: 22),
        Positioned(
          right: -2,
          bottom: -2,
          child: Icon(Icons.schedule, size: 12, color: AppColors.accent),
        ),
      ],
    ),
  );
}

/// Modal dialog: staff dropdown + Mon–Sun shift times from API.
Future<void> showShiftScheduleDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const _ShiftScheduleDialog(),
  );
}

String _formatShiftTimePart(String hhmmss) {
  final parts = hhmmss.split(':');
  final h = int.tryParse(parts.isNotEmpty ? parts[0] : '0') ?? 0;
  final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
  final hs = h.toString().padLeft(2, '0');
  if (m == 0) {
    return '${hs}h';
  }
  return '$hs:${m.toString().padLeft(2, '0')}';
}

String _formatShiftRange(String start, String end) {
  return '${_formatShiftTimePart(start)} - ${_formatShiftTimePart(end)}';
}

class _ShiftScheduleDialog extends StatefulWidget {
  const _ShiftScheduleDialog();

  @override
  State<_ShiftScheduleDialog> createState() => _ShiftScheduleDialogState();
}

class _ShiftScheduleDialogState extends State<_ShiftScheduleDialog> {
  bool _loading = true;
  String? _errorMessage;
  List<StaffMemberSchedule> _schedules = [];
  String? _selectedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final venueId = context.read<AuthProvider>().currentVenueId;
    final api = context.read<StaffSchedulesApi>();
    final authUserId = context.read<AuthProvider>().user?.id;

    if (venueId == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = null;
        _schedules = [];
        _selectedUserId = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final list = await api.getVenueCalendar(venueId);
      list.sort(
        (a, b) => a.user.displayName.toLowerCase().compareTo(
              b.user.displayName.toLowerCase(),
            ),
      );
      String? selected;
      if (list.isNotEmpty) {
        final idx = list.indexWhere((e) => e.user.id == authUserId);
        selected = list[idx >= 0 ? idx : 0].user.id;
      }
      if (!mounted) return;
      setState(() {
        _schedules = list;
        _selectedUserId = selected;
        _loading = false;
        _errorMessage = null;
      });
    } on StaffSchedulesException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = '';
      });
    }
  }

  /// Valid dropdown value; falls back to first staff if selection is stale.
  String? get _resolvedUserId {
    if (_schedules.isEmpty) return null;
    final id = _selectedUserId;
    if (id != null && _schedules.any((e) => e.user.id == id)) {
      return id;
    }
    return _schedules.first.user.id;
  }

  StaffMemberSchedule? get _selected {
    final id = _resolvedUserId;
    if (id == null) return null;
    try {
      return _schedules.firstWhere((e) => e.user.id == id);
    } catch (_) {
      return _schedules.isEmpty ? null : _schedules.first;
    }
  }

  String _weekdayLabel(BuildContext context, int weekday) {
    final locale = Localizations.localeOf(context);
    final d = DateTime(2024, 1, 1 + (weekday - 1));
    return DateFormat.EEEE(locale.toString()).format(d);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final maxW = MediaQuery.sizeOf(context).width - 48;
    final dialogWidth = math.min(400.0, math.max(280.0, maxW));

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: dialogWidth,
        height: 480,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.shiftScheduleDialogTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              if (_loading)
                Expanded(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.shiftScheduleLoadError,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (_errorMessage!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                          TextButton(
                            onPressed: _load,
                            child: Text(l10n.shiftScheduleRetry),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (_schedules.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      l10n.shiftScheduleEmpty,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _resolvedUserId,
                      items: _schedules
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e.user.id,
                              child: Text(e.user.displayName),
                            ),
                          )
                          .toList(),
                      onChanged: (id) {
                        if (id != null) {
                          setState(() => _selectedUserId = id);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: 7,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      final weekday = DateTime.monday + index;
                      final sel = _selected;
                      final shift = sel?.shiftsByWeekday[weekday];
                      final timeStr = shift != null
                          ? _formatShiftRange(
                              shift.startTime,
                              shift.endTime,
                            )
                          : '—';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _weekdayLabel(context, weekday),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Text(
                              timeStr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: shift != null
                                    ? AppColors.accent
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
