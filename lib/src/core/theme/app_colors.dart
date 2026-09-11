import 'package:flutter/material.dart';

/// Brand accents and each game's signature gradient. The UI is deliberately
/// near-monochrome: surfaces are neutral, and a game's gradient is reduced
/// to a single accent (its first stop — see [accentOf]) that appears only in
/// small doses: an icon tint, a selection ring, an eyebrow label. The
/// gradients themselves stay defined so a game's identity lives in one place.
abstract final class AppColors {
  static const seed = Color(0xFF7C4DFF);

  /// Fill behind key art on the hub cards: near-black in both themes, so
  /// the picture's own darks blend into it and white text always reads.
  static const artBase = Color(0xFF15131A);

  /// The one accent a surface is allowed to use for a game.
  static Color accentOf(Gradient gradient) => gradient.colors.first;

  /// Nudges an accent toward the foreground so it stays readable as small
  /// text on that [brightness]'s surfaces (amber and teal accents in
  /// particular wash out on white).
  static Color legible(Color accent, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    return Color.alphaBlend(
      (isLight ? Colors.black : Colors.white).withValues(
        alpha: isLight ? 0.28 : 0.18,
      ),
      accent,
    );
  }

  /// Faint tint of an accent for chips and card fills.
  static Color tint(Color accent, ColorScheme scheme) => Color.alphaBlend(
    accent.withValues(alpha: scheme.brightness == Brightness.dark ? 0.18 : 0.1),
    scheme.surfaceContainerLow,
  );

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

  /// Never Have I Ever — a cheeky pink-to-violet blush.
  static const confessionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF5FA2), Color(0xFF8E5CF6)],
  );

  /// Most Likely To — a warm orange-to-teal spotlight.
  static const spotlightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F1C), Color(0xFF2EC4B6)],
  );

  /// Truth or Dare — a bold green-to-sky dare.
  static const dareGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
  );

  /// Heads Up — a clear blue-to-violet signal.
  static const signalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
  );
}
