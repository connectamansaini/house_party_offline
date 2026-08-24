import 'package:flutter/material.dart';

/// Brand accents and the vivid gradients used on hero surfaces and gameplay
/// cards. These are intentionally fixed (not scheme-derived) so the dramatic
/// moments — the imposter reveal, a win banner — read the same punch in both
/// light and dark themes.
abstract final class AppColors {
  static const seed = Color(0xFF7C4DFF);

  static const violet = Color(0xFF7C4DFF);
  static const magenta = Color(0xFFFF4D8D);
  static const cyan = Color(0xFF19E3D2);
  static const amber = Color(0xFFFFB020);

  /// Civilian / "the good guys" — cool and confident.
  static const civilianGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C2A8), Color(0xFF008FC7)],
  );

  /// Imposter — ominous hot magenta-to-red.
  static const imposterGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF4D6D), Color(0xFFB5179E)],
  );

  /// Brand / hero surfaces (home & landing banners).
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C4DFF), Color(0xFFFF4D8D)],
  );

  /// Celebration — used on the game-over / winner surfaces.
  static const winGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB020), Color(0xFFFF6D3B)],
  );

  /// Mafia game / the mafia faction — dark, ominous crimson.
  static const mafiaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC1121F), Color(0xFF6A040F)],
  );

  /// Night phase surfaces — deep indigo.
  static const nightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3A0CA3), Color(0xFF10002B)],
  );

  /// On-gradient foreground (text/icons sit on the vivid gradients above).
  static const Color onGradient = Colors.white;
}
