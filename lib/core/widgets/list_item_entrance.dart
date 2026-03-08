import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps a list item with an entrance animation (fade + slide).
/// Use in ListView.itemBuilder to animate list items on appear.
/// Set [stagger] to false in scrollable lists to avoid empty space and long
/// delays when scrolling fast (items then animate in immediately when built).
class ListItemEntrance extends StatelessWidget {
  const ListItemEntrance({
    super.key,
    required this.index,
    required this.child,
    this.intervalMs = 50,
    this.durationMs = 350,
    this.stagger = false,
  });

  final int index;
  final Widget child;
  final int intervalMs;
  final int durationMs;
  /// If false, delay is 0 so items appear as soon as they're built. Use for scrollable lists.
  final bool stagger;

  @override
  Widget build(BuildContext context) {
    final delayMs = stagger ? index * intervalMs : 0;
    final duration = stagger ? durationMs : 180;
    return child
        .animate()
        .fadeIn(
          delay: delayMs.ms,
          duration: duration.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.02,
          end: 0,
          delay: delayMs.ms,
          duration: duration.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
