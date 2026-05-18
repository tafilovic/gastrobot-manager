import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/log/app_logger.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/notifications/domain/bot_response_payload.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';
import 'package:gastrobotmanager/features/notifications/domain/socket_connection_state.dart';
import 'package:gastrobotmanager/features/notifications/domain/socket_events.dart';

/// Global Socket.IO client for realtime notifications.
///
/// Mirrors the web panel connection:
/// `io(BACKEND_URL, { autoConnect: false, transports: ['websocket'], query: { userId, venueId } })`
///
/// Subscribe via [notifications] and [botResponses] broadcast streams.
class SocketNotificationService extends ChangeNotifier {
  SocketNotificationService(this._authProvider) {
    _authProvider.addListener(_onAuthChanged);
  }

  final AuthProvider _authProvider;

  final StreamController<NotificationPayload> _notificationController =
      StreamController<NotificationPayload>.broadcast();
  final StreamController<BotResponsePayload> _botResponseController =
      StreamController<BotResponsePayload>.broadcast();

  io.Socket? _socket;
  SocketConnectionState _connectionState = SocketConnectionState.disconnected;
  String? _connectedUserId;
  String? _connectedVenueId;

  /// Emitted for each `notification` socket event.
  Stream<NotificationPayload> get notifications =>
      _notificationController.stream;

  /// Emitted for each `bot_response` socket event.
  Stream<BotResponsePayload> get botResponses => _botResponseController.stream;

  SocketConnectionState get connectionState => _connectionState;

  bool get isConnected => _connectionState == SocketConnectionState.connected;

  /// Connects when logged in with a valid [AuthProvider.currentVenueId].
  void connect() {
    if (!_authProvider.isLoggedIn) {
      disconnect();
      return;
    }

    final userId = _authProvider.user?.id;
    final venueId = _authProvider.currentVenueId;
    if (userId == null || venueId == null) {
      debugLog(
        'SocketNotificationService: skip connect (userId=$userId venueId=$venueId)',
      );
      return;
    }

    if (_socket != null &&
        _connectedUserId == userId &&
        _connectedVenueId == venueId &&
        isConnected) {
      return;
    }

    disconnect();

    _connectedUserId = userId;
    _connectedVenueId = venueId;
    _setConnectionState(SocketConnectionState.connecting);

    debugLog(
      'SocketNotificationService: connecting userId=$userId venueId=$venueId',
    );

    final socket = io.io(
      ApiConfig.baseUrl,
      io.OptionBuilder()
          .disableAutoConnect()
          .setTransports(['websocket'])
          .setQuery({'userId': userId, 'venueId': venueId})
          .build(),
    );

    socket.onConnect((_) {
      debugLog('SocketNotificationService: connected');
      _setConnectionState(SocketConnectionState.connected);
    });

    socket.onDisconnect((_) {
      debugLog('SocketNotificationService: disconnected');
      if (_socket != null) {
        _setConnectionState(SocketConnectionState.disconnected);
      }
    });

    socket.onConnectError((error) {
      debugLog('SocketNotificationService: connect error $error');
      _setConnectionState(SocketConnectionState.error);
    });

    socket.onError((error) {
      debugLog('SocketNotificationService: error $error');
    });

    socket.on(SocketEvents.notification, _handleNotification);
    socket.on(SocketEvents.botResponse, _handleBotResponse);

    _socket = socket;
    socket.connect();
  }

  void disconnect() {
    _connectedUserId = null;
    _connectedVenueId = null;
    final socket = _socket;
    _socket = null;
    if (socket != null) {
      socket.off(SocketEvents.notification);
      socket.off(SocketEvents.botResponse);
      socket.dispose();
    }
    _setConnectionState(SocketConnectionState.disconnected);
    debugLog('SocketNotificationService: disconnect');
  }

  void _onAuthChanged() {
    if (!_authProvider.isLoggedIn) {
      disconnect();
      return;
    }
    connect();
  }

  void _handleNotification(dynamic data) {
    final payload = NotificationPayload.fromDynamic(data);
    if (payload == null) {
      debugLog('SocketNotificationService: ignored notification payload $data');
      return;
    }
    debugLog(
      'SocketNotificationService: notification type=${payload.type} id=${payload.id}',
    );
    if (!_notificationController.isClosed) {
      _notificationController.add(payload);
    }
  }

  void _handleBotResponse(dynamic data) {
    final payload = BotResponsePayload.fromDynamic(data);
    if (payload == null) {
      debugLog('SocketNotificationService: ignored bot_response payload $data');
      return;
    }
    debugLog('SocketNotificationService: bot_response type=${payload.type}');
    if (!_botResponseController.isClosed) {
      _botResponseController.add(payload);
    }
  }

  void _setConnectionState(SocketConnectionState state) {
    if (_connectionState == state) return;
    _connectionState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    disconnect();
    unawaited(_notificationController.close());
    unawaited(_botResponseController.close());
    super.dispose();
  }
}
