import 'package:flutter/material.dart';

/// A page route with fade and slide-from-right transition.
/// Use instead of [MaterialPageRoute] for consistent screen transitions.
class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  FadeSlidePageRoute({
    required Widget Function(BuildContext) builder,
    super.settings,
    Duration duration = const Duration(milliseconds: 280),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeOutCubic;
            final curved = CurvedAnimation(
              parent: animation,
              curve: curve,
              reverseCurve: Curves.easeInCubic,
            );
            final fade = Tween<double>(begin: 0, end: 1).animate(curved);
            final slide = Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(curved);
            return FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
        );
}
