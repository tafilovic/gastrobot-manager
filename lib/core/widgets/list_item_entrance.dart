import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps a list item with a staggered entrance animation (fade + slide).
/// Use in ListView.itemBuilder to animate list items on appear.
class ListItemEntrance extends StatelessWidget {
  const ListItemEntrance({
    super.key,
    required this.index,
    required this.child,
    this.intervalMs = 50,
    this.durationMs = 350,
  });

  final int index;
  final Widget child;
  final int intervalMs;
  final int durationMs;

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(
          delay: (index * intervalMs).ms,
          duration: durationMs.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.04,
          end: 0,
          delay: (index * intervalMs).ms,
          duration: durationMs.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
