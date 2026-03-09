import 'package:flutter/material.dart';

/// Represents a bottom navigation item.
class NavItem {
  const NavItem({
    required this.label,
    this.icon, // optional for Material icons
    this.svgAssetPath, // e.g. 'assets/icons/orders.svg'
    required this.route,
  }) : assert(icon != null || svgAssetPath != null);

  final String label;
  final IconData? icon;
  final String? svgAssetPath;
  final String route;
}
