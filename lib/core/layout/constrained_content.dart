import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';

/// Wraps content with horizontal padding and, on wide screens, centers it
/// with a max width so lists don't stretch on tablet/desktop.
class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.contentMaxWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useConstraint = width > AppBreakpoints.compact;

    return Padding(
      padding: padding,
      child: useConstraint
          ? Center(
              child: SizedBox(
                width: width > maxWidth ? maxWidth : null,
                child: child,
              ),
            )
          : child,
    );
  }
}
