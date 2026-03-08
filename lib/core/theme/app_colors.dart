import 'package:flutter/material.dart';

/// Centralized app colors. Change here to update colors across the app.
abstract final class AppColors {
  AppColors._();

  // --- Primary / accent
  static const Color accent = Color(0xFF0029C1);

  // --- Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);
  /// Muted background (e.g. list screens).
  static const Color backgroundMuted = Color(0xFFF5F5F5);

  // --- Text
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF757575);
  /// Icons and secondary UI (grey[600] equivalent).
  static const Color textMuted = Color(0xFF757575);

  // --- Borders & shadow
  static const Color border = Color(0xFFE0E0E0);
  static Color get shadow => Colors.black.withValues(alpha: 0.08);

  // --- Actions & states
  static const Color destructive = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onDestructive = Color(0xFFFFFFFF);
  static const Color onSuccess = Color(0xFFFFFFFF);

  // --- AppBar / nav
  static const Color appBarBackground = Color(0xFFFFFFFF);
  static const Color appBarForeground = Color(0xFF000000);
}
