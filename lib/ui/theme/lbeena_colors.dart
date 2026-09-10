import 'package:flutter/material.dart';

/// Brand tokens.
///
/// Primary colors ([teal], [orange], [tealDark], [orangeDeep]) are loaded from
/// the backend `mobile/app_colors` API (`color1` / `color2` / `color3`) and
/// fall back to the Lbeena logo palette until that response arrives.
///
/// Neutral surfaces stay local so cards, borders, and text remain readable.
class LbeenaColors {
  LbeenaColors._();

  static const Color _fallbackOrange = Color(0xFFF58220);
  static const Color _fallbackOrangeDeep = Color(0xFFE56A1A);
  static const Color _fallbackTeal = Color(0xFF1F6B66);
  static const Color _fallbackTealDark = Color(0xFF164E4A);
  static const Color splashStart = Color(0xFF183B4E);

  static Color _orange = _fallbackOrange;
  static Color _orangeDeep = _fallbackOrangeDeep;
  static Color _teal = _fallbackTeal;
  static Color _tealDark = _fallbackTealDark;

  static Color get orange => _orange;
  static Color get orangeDeep => _orangeDeep;
  static Color get teal => _teal;
  static Color get tealDark => _tealDark;
  static Color get fallbackTeal => _fallbackTeal;

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
  static const Color star = Color(0xFFF5B400);

  /// `color1` = primary (headers, labels), `color2` = secondary,
  /// `color3` = accent (buttons, prices).
  static void applyFromBackend({
    String? color1,
    String? color2,
    String? color3,
  }) {
    _teal = _parseHex(color1) ?? _fallbackTeal;
    _orange = _parseHex(color3) ?? _parseHex(color2) ?? _fallbackOrange;
    _orangeDeep = _parseHex(color2) ?? _darken(_orange);
    _tealDark = _darken(_teal);
  }

  static Color? _parseHex(String? raw) {
    if (raw == null) return null;
    var hex = raw.trim().replaceAll('#', '');
    if (hex.toLowerCase().startsWith('0x')) {
      hex = hex.substring(2);
    }
    if (hex.toLowerCase().startsWith('ff') && hex.length == 8) {
      hex = hex.substring(2);
    }
    if (hex.length != 6) return null;
    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }

  static Color _darken(Color color, [double amount = 0.16]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static BoxDecoration get card => cardWith();

  static BoxDecoration cardWith({Color? color}) => BoxDecoration(
        color: color ?? white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: fieldBorder),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      );
}
