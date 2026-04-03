import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

// -----------------------------------------------------------------------------
// Google Play In-App Updates — ANDROID ONLY
//
// Uses Play Core "flexible" mode: the user can keep using the app while the new
// version downloads; when ready we show a snackbar so they can restart and apply.
// Immediate/full-screen blocking updates are intentionally not used here.
//
// Requirements: app installed from Google Play (internal/open/production tracks).
// No effect on iOS, desktop, or web — [run] returns immediately on those targets.
// -----------------------------------------------------------------------------

/// Coordinates the flexible in-app update flow for Android (see file header).
class AndroidFlexibleUpdateCoordinator {
  AndroidFlexibleUpdateCoordinator._();

  static StreamSubscription<InstallStatus>? _installSub;
  static bool _restartSnackShown = false;

  /// Clears Play install listener state; call from app dispose (Android only matters).
  static void dispose() {
    _installSub?.cancel();
    _installSub = null;
    _restartSnackShown = false;
  }

  /// Checks Play for an update and starts flexible download if allowed.
  /// Safe to call on every platform: non-Android exits without calling Play APIs.
  /// Call after the first frame so [scaffoldMessengerKey] is under [MaterialApp].
  static Future<void> run({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) async {
    // Android-only: in_app_update wraps Play Core; other platforms must not invoke it.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.flexibleUpdateAllowed) {
        final result = await InAppUpdate.startFlexibleUpdate();
        if (result == AppUpdateResult.success) {
          _listenForDownloadComplete(scaffoldMessengerKey);
        }
        return;
      }

      // App was restarted mid-download; payload already on device.
      if (info.updateAvailability ==
              UpdateAvailability.developerTriggeredUpdateInProgress &&
          info.installStatus == InstallStatus.downloaded) {
        _showRestartSnackBar(scaffoldMessengerKey);
        return;
      }

      // Download still in progress after process restart — reattach listener.
      if (info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        _listenForDownloadComplete(scaffoldMessengerKey);
      }
    } on Object catch (e, st) {
      debugPrint('AndroidFlexibleUpdateCoordinator: $e');
      debugPrint('$st');
    }
  }

  static void _listenForDownloadComplete(
    GlobalKey<ScaffoldMessengerState> key,
  ) {
    _installSub?.cancel();
    _installSub = InAppUpdate.installUpdateListener.listen((status) {
      if (status == InstallStatus.downloaded) {
        _showRestartSnackBar(key);
      }
    });
  }

  static void _showRestartSnackBar(
    GlobalKey<ScaffoldMessengerState> key,
  ) {
    if (_restartSnackShown) {
      return;
    }
    _restartSnackShown = true;
    _installSub?.cancel();
    _installSub = null;

    key.currentState?.showSnackBar(
      SnackBar(
        content: const Text(
          'A new version is ready. Tap Restart to apply the update.',
        ),
        action: SnackBarAction(
          label: 'Restart',
          onPressed: () {
            unawaited(InAppUpdate.completeFlexibleUpdate());
          },
        ),
      ),
    );
  }
}
