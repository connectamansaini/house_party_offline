import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:house_party_offline/core/design/app_page_transitions.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';

/// Near-monochrome Material theme. The seed only tints the neutrals; the
/// primary role is "ink" (near-black on light, near-white on dark) so filled
/// buttons, pips and selection reads are colorless and the per-game accents
/// are the only real color on screen.
abstract final class AppTheme {
  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static const _inkLight = Color(0xFF17151C);
  static const _inkDark = Color(0xFFF3F1F7);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final seeded = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    );
    final colorScheme = seeded.copyWith(
      primary: isDark ? _inkDark : _inkLight,
      onPrimary: isDark ? _inkLight : Colors.white,
      primaryContainer: seeded.surfaceContainerHighest,
      onPrimaryContainer: seeded.onSurface,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
    );
    final text = _textTheme(base.textTheme);
    final hairline = BorderSide(
      color: colorScheme.outlineVariant.withValues(alpha: 0.7),
    );

    return base.copyWith(
      textTheme: text,
      // One transition for every route on every platform; on Android it
      // also follows the predictive back gesture.
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: const AppPageTransitionsBuilder(),
        },
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        // A transparent app bar makes Flutter guess light status-bar icons;
        // pin them to the page surface instead so the clock stays legible.
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.x3l),
          side: hairline,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.x4l),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          side: hairline,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.x4l),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          borderSide: hairline,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          borderSide: hairline,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xl),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.x2l),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        space: 32,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    // Manrope everywhere as the body/UI face; the weight and tracking
    // tweaks below are layered back on top per role.
    final text = base.apply(fontFamily: 'Manrope');

    return text.copyWith(
      displayLarge: text.displayLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      displayMedium: text.displayMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      displaySmall: text.displaySmall?.copyWith(fontWeight: FontWeight.w800),
      headlineLarge: text.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      headlineMedium: text.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
