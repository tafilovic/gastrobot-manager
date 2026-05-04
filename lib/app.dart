import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/l10n/cupertino_localizations_fallback_delegate.dart';
import 'package:gastrobotmanager/core/l10n/locale_provider.dart';
import 'package:gastrobotmanager/core/l10n/material_localizations_fallback_delegate.dart';
// Android-only: Google Play flexible in-app update (see coordinator file header).
import 'package:gastrobotmanager/core/update/android_flexible_update_coordinator.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/theme/app_scroll_behavior.dart';
import 'package:gastrobotmanager/core/theme/app_theme.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/notifications/services/push_notification_service.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

class GastroBotApp extends StatefulWidget {
  const GastroBotApp({super.key});

  @override
  State<GastroBotApp> createState() => _GastroBotAppState();
}

class _GastroBotAppState extends State<GastroBotApp> {
  late final GoRouter _router;

  /// Used for the Android Play-update "restart to apply" snackbar (ignored elsewhere).
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _router = AppRouter.create(auth);
    context.read<PushNotificationService>().setTapHandler(
      _handleNotificationTap,
    );
    // Android-only Play flexible update check; coordinator no-ops on other platforms.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        AndroidFlexibleUpdateCoordinator.run(
          scaffoldMessengerKey: _scaffoldMessengerKey,
        ),
      );
    });
  }

  @override
  void dispose() {
    AndroidFlexibleUpdateCoordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return MaterialApp.router(
          // Snackbars for Android Play flexible update completion (harmless on other platforms).
          scaffoldMessengerKey: _scaffoldMessengerKey,
          title: 'GastroCrew',
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          scrollBehavior: const AppScrollBehavior(),
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            MaterialLocalizationsFallbackDelegate(),
            CupertinoLocalizationsFallbackDelegate(),
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
          builder: (context, child) {
            context.read<PushNotificationService>().updateLocalizations(
              AppLocalizations.of(context),
            );
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }

  void _handleNotificationTap(Map<String, String> payload) {
    final subtype = payload['subtype'];
    if (subtype == 'food_ready' || subtype == 'drinks_ready') {
      _router.go(AppRouteNames.pathReady);
      return;
    }

    switch (payload['type']) {
      case 'reservation':
      case 'reservation_reminder':
        _router.go(AppRouteNames.pathReservations);
        return;
      case 'kitchen':
        _router.go(AppRouteNames.pathPreparing);
        return;
      case 'order':
      case 'item_rejection':
      case 'item_accepted':
        _router.go(AppRouteNames.pathOrders);
        return;
      default:
        _router.go(AppRouteNames.pathOrders);
    }
  }
}
