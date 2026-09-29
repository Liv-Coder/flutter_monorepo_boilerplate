/// Font family names used across the design system.
///
/// These names map directly to Google Fonts families. Changing a family here
/// propagates through AppTypography and every screen without touching
/// feature code.
class AppFonts {
  const AppFonts._();

  /// Primary font for headings and display text.
  static const String display = 'Inter';

  /// Primary font for body text and UI labels.
  static const String body = 'Inter';

  /// Monospace font for counters, code blocks, and tabular data.
  static const String mono = 'JetBrains Mono';
}
