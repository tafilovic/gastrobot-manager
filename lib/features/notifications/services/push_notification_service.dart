import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:gastrobotmanager/core/log/app_logger.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/notifications/data/device_token_remote.dart';
import 'package:gastrobotmanager/features/notifications/data/notification_localizer.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';
import 'package:gastrobotmanager/firebase_options.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations_en.dart';

typedef NotificationTapHandler = void Function(Map<String, String> payload);

class PushNotificationService {
  PushNotificationService({
    required AuthProvider authProvider,
    required DeviceTokenRemote tokenRemote,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    NotificationLocalizer localizer = const NotificationLocalizer(),
  }) : _authProvider = authProvider,
       _tokenRemote = tokenRemote,
       _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin(),
       _localizer = localizer;

  static const _channelId = 'gastrocrew_operations';
  static const _channelName = 'Operations';
  static const _channelDescription =
      'Order, reservation, kitchen, bar and waiter notifications.';

  final AuthProvider _authProvider;
  final DeviceTokenRemote _tokenRemote;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final NotificationLocalizer _localizer;

  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  StreamSubscription<String>? _tokenSubscription;
  NotificationTapHandler? _tapHandler;
  AppLocalizations? _localizations;
  bool _initialized = false;
  bool _started = false;
  String? _lastRegisteredToken;

  bool get _isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> initialize() async {
    if (_initialized || !_isSupported) return;
    _initialized = true;

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    const androidInitialization = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: androidInitialization,
    );
    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = NotificationPayload.fromLocalPayload(response.payload);
        if (payload != null) {
          _tapHandler?.call(payload.routePayload);
        }
      },
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    _messageSubscription = FirebaseMessaging.onMessage.listen(
      _showForegroundNotification,
    );
    _openedSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleRemoteMessageTap,
    );
    _tokenSubscription = _messaging.onTokenRefresh.listen((token) {
      unawaited(_registerToken(token));
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleRemoteMessageTap(initialMessage);
    }
  }

  Future<void> start() async {
    if (_started || !_isSupported) return;
    _started = true;
    await initialize();
    await registerCurrentToken();
  }

  Future<void> registerCurrentToken() async {
    if (!_isSupported || !_authProvider.isLoggedIn) return;
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;
    await _registerToken(token);
  }

  void updateLocalizations(AppLocalizations? localizations) {
    _localizations = localizations;
  }

  void setTapHandler(NotificationTapHandler handler) {
    _tapHandler = handler;
  }

  void clearRegisteredTokenCache() {
    _lastRegisteredToken = null;
  }

  Future<void> _registerToken(String token) async {
    if (!_authProvider.isLoggedIn || token == _lastRegisteredToken) return;
    debugLog('Registering FCM token for android: $token');
    await _tokenRemote.registerToken(token: token, platform: 'android');
    _lastRegisteredToken = token;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    _logRemoteMessage('foreground', message);
    final payload = NotificationPayload.fromRemoteData(message.data);
    final notification = message.notification;
    final localizations = _localizations ?? AppLocalizationsEn();
    final text = payload == null
        ? null
        : _localizer.resolve(payload, localizations);
    final title = payload == null ? notification?.title : text?.title;
    final body = payload == null ? notification?.body : text?.body;

    if (title == null || title.isEmpty) return;

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: payload?.toLocalPayload(),
    );
  }

  void _handleRemoteMessageTap(RemoteMessage message) {
    _logRemoteMessage('tap', message);
    final payload = NotificationPayload.fromRemoteData(message.data);
    if (payload != null) {
      _tapHandler?.call(payload.routePayload);
    }
  }

  static void _logRemoteMessage(String source, RemoteMessage message) {
    debugLog(
      'FCM $source message: '
      'messageId=${message.messageId}, '
      'sentTime=${message.sentTime?.toIso8601String()}, '
      'data=${jsonEncode(message.data)}, '
      'notificationTitle=${message.notification?.title}, '
      'notificationBody=${message.notification?.body}',
    );
  }

  Future<void> dispose() async {
    await _messageSubscription?.cancel();
    await _openedSubscription?.cancel();
    await _tokenSubscription?.cancel();
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  PushNotificationService._logRemoteMessage('background', message);
  final payload = NotificationPayload.fromRemoteData(message.data);
  if (payload == null || message.notification != null) return;

  const localizer = NotificationLocalizer();
  final text = localizer.resolve(payload, AppLocalizationsEn());
  final plugin = FlutterLocalNotificationsPlugin();
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  await plugin.initialize(settings: initializationSettings);
  await plugin.show(
    id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
    title: text.title,
    body: text.body,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        PushNotificationService._channelId,
        PushNotificationService._channelName,
        channelDescription: PushNotificationService._channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: jsonEncode(payload.toJson()),
  );
}
