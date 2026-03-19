/// Breakpoints for responsive layout. Use with MediaQuery or LayoutBuilder.
abstract final class AppBreakpoints {
  /// Below: phone layout (bottom nav, full-width content).
  static const double compact = 600;

  /// Above compact: tablet/desktop (rail, constrained content).
  static const double medium = 600;

  /// Above: optional larger width for master-detail layout.
  static const double expanded = 900;

  /// Max width for list/content on medium+ screens (avoid stretched lists).
  static const double contentMaxWidth = 640;

  /// Max width when content uses 2 columns (menu grid, food/drinks side-by-side).
  static const double contentMaxWidthWide = 1100;

  /// Max width for master-detail layout (list + detail panes).
  static const double contentMaxWidthMasterDetail = 1600;
}
