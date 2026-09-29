// ignore_for_file: prefer_const_constructors
// GoogleFonts.getFont returns a non-const TextStyle — this is expected and
// cannot be fixed without abandoning typed font factories.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_fonts.dart';

/// Type scale for the design system.
///
/// Every style has a named purpose. All styles are built from Google Fonts.
/// Font family names are centralised in [AppFonts].
///
/// Feature code reads typography through [Theme.of(context).textTheme].
/// Do not import `google_fonts` outside this file.
class AppTypography {
  const AppTypography._();

  /// 32 / w700 — hero headings, screen titles.
  static TextStyle get heading1 => GoogleFonts.getFont(
        AppFonts.display,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// 24 / w600 — section headings.
  static TextStyle get heading2 => GoogleFonts.getFont(
        AppFonts.display,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.25,
      );

  /// 20 / w600 — card headers, subsection titles.
  static TextStyle get heading3 => GoogleFonts.getFont(
        AppFonts.display,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  /// 16 / w400 — primary reading content.
  static TextStyle get body => GoogleFonts.getFont(
        AppFonts.body,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// 14 / w400 — secondary and supporting text.
  static TextStyle get bodySmall => GoogleFonts.getFont(
        AppFonts.body,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  /// 12 / w400 — captions, metadata, timestamps.
  static TextStyle get caption => GoogleFonts.getFont(
        AppFonts.body,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  /// 14 / w600 — button labels, field labels, emphasis.
  static TextStyle get label => GoogleFonts.getFont(
        AppFonts.body,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
      );

  /// 14 / w400 monospace — counters, code snippets, tabular numbers.
  static TextStyle get mono => GoogleFonts.getFont(
        AppFonts.mono,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );
}
