import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Scroll behavior that enables drag scrolling for mouse, touch, and stylus.
///
/// This allows pull-to-refresh with a primary mouse button drag on desktop
/// platforms (Windows, macOS, Linux) and on web, in addition to touch.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

