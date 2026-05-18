import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/core/log/app_logger.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/notifications/domain/bot_response_payload.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_refresh_target.dart';
import 'package:gastrobotmanager/features/notifications/providers/tab_badge_provider.dart';
import 'package:gastrobotmanager/features/notifications/services/socket_notification_service.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/confirmed_reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';

/// Routes socket (and optional FCM) notifications to list refresh and nav badges.
class NotificationRealtimeCoordinator {
  NotificationRealtimeCoordinator({
    required SocketNotificationService socketService,
    required AuthProvider authProvider,
    required OrdersProvider ordersProvider,
    required ReservationsProvider reservationsProvider,
    required ConfirmedReservationsProvider confirmedReservationsProvider,
    required TabBadgeProvider tabBadgeProvider,
  }) : _socketService = socketService,
       _authProvider = authProvider,
       _ordersProvider = ordersProvider,
       _reservationsProvider = reservationsProvider,
       _confirmedReservationsProvider = confirmedReservationsProvider,
       _tabBadgeProvider = tabBadgeProvider;

  static const Duration _dedupeWindow = Duration(seconds: 2);

  final SocketNotificationService _socketService;
  final AuthProvider _authProvider;
  final OrdersProvider _ordersProvider;
  final ReservationsProvider _reservationsProvider;
  final ConfirmedReservationsProvider _confirmedReservationsProvider;
  final TabBadgeProvider _tabBadgeProvider;

  StreamSubscription<NotificationPayload>? _notificationSub;
  StreamSubscription<BotResponsePayload>? _botResponseSub;

  String? _lastDedupeKey;
  DateTime? _lastDedupeAt;

  void start() {
    _notificationSub ??= _socketService.notifications.listen(_onNotification);
    _botResponseSub ??= _socketService.botResponses.listen(_onBotResponse);
  }

  void stop() {
    unawaited(_notificationSub?.cancel());
    unawaited(_botResponseSub?.cancel());
    _notificationSub = null;
    _botResponseSub = null;
  }

  /// Called from [PushNotificationService] when a foreground FCM message arrives.
  void handleForegroundPayload(NotificationPayload payload) {
    _dispatch(
      target: NotificationRefreshTargetMapper.fromPayload(payload),
      dedupeKey: _dedupeKeyFor(payload),
    );
  }

  void _onNotification(NotificationPayload payload) {
    _dispatch(
      target: NotificationRefreshTargetMapper.fromPayload(payload),
      dedupeKey: _dedupeKeyFor(payload),
    );
  }

  void _onBotResponse(BotResponsePayload payload) {
    _dispatch(
      target: NotificationRefreshTargetMapper.fromBotResponse(payload),
      dedupeKey: 'bot:${payload.type}',
    );
  }

  static String _dedupeKeyFor(NotificationPayload payload) {
    if (payload.id != null && payload.id!.isNotEmpty) return payload.id!;
    final entity = payload.entityId ?? '';
    final type = payload.type ?? '';
    return '$type:$entity:${payload.titleKey}';
  }

  void _dispatch({
    required NotificationRefreshTarget target,
    required String dedupeKey,
  }) {
    if (target == NotificationRefreshTarget.none) return;
    if (_isDuplicate(dedupeKey)) return;

    final venueId = _authProvider.currentVenueId;
    if (venueId == null) return;

    unawaited(_refreshTarget(target, venueId));

    final routeKey = NotificationRefreshTargetMapper.routeKeyFor(target);
    if (routeKey != null && _tabBadgeProvider.activeRouteKey != routeKey) {
      _tabBadgeProvider.markUnread(target);
    }
  }

  bool _isDuplicate(String key) {
    final now = DateTime.now();
    if (_lastDedupeKey == key &&
        _lastDedupeAt != null &&
        now.difference(_lastDedupeAt!) < _dedupeWindow) {
      return true;
    }
    _lastDedupeKey = key;
    _lastDedupeAt = now;
    return false;
  }

  Future<void> _refreshTarget(
    NotificationRefreshTarget target,
    String venueId,
  ) async {
    try {
      switch (target) {
        case NotificationRefreshTarget.orders:
          debugLog('NotificationRealtimeCoordinator: refresh orders');
          await _ordersProvider.loadOnce(venueId);
        case NotificationRefreshTarget.reservations:
          debugLog('NotificationRealtimeCoordinator: refresh reservations');
          await _refreshReservations(venueId);
        case NotificationRefreshTarget.none:
          break;
      }
    } catch (error, stack) {
      debugLog(
        'NotificationRealtimeCoordinator: refresh failed $error\n$stack',
      );
    }
  }

  Future<void> _refreshReservations(String venueId) async {
    if (_authProvider.profileType == ProfileType.waiter) {
      await _reservationsProvider.pullRefresh();
      await _refreshConfirmedIfLoaded();
    } else {
      await _reservationsProvider.loadOnce(venueId);
    }
  }

  /// Refreshes accepted list only after the user has opened that tab at least once.
  Future<void> _refreshConfirmedIfLoaded() async {
    if (!_confirmedReservationsProvider.hasLoadedOnce) return;
    await _confirmedReservationsProvider.pullRefresh();
  }

  void dispose() {
    stop();
  }
}
