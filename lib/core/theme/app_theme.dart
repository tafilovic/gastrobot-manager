import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _accentBlue = Color(0xFF2196F3);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _accentBlue, brightness: Brightness.light),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: _accentBlue.withValues(alpha: 0.15),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _accentBlue,
            );
          }
          return TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: _accentBlue, size: 24);
          }
          return IconThemeData(color: Colors.grey[600], size: 24);
        }),
      ),
    );
  }
}
