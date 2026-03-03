import 'package:flutter/material.dart';

/// Represents a bottom navigation item.
class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
