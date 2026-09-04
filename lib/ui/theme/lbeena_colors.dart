import 'package:flutter/material.dart';

/// Brand tokens extracted from the Lbeena logos (not from the backend).
/// Orange megaphone + teal wordmark on black.
///
/// Pairing rule: teal/green is only used with white or orange — never with black.
/// On a teal background, text and icons must be white or orange.
class LbeenaColors {
  LbeenaColors._();

  static const Color orange = Color(0xFFF58220);
  static const Color orangeDeep = Color(0xFFE56A1A);
  static const Color teal = Color(0xFF1F6B66);
  static const Color tealDark = Color(0xFF164E4A);
  static const Color black = Color(0xFF0D0D0D);
  static const Color surfaceDark = Color(0xFF161616);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightBg = Color(0xFFF5F5F5);
  static const Color muted = Color(0xFF6B7280);
  static const Color fieldFill = Color(0xFFFFFFFF);
  static const Color fieldBorder = Color(0xFFE5E7EB);
  static const Color iconTile = Color(0xFFF2F2F2);
  static const Color fieldHint = Color(0xFF9CA3AF);
}
