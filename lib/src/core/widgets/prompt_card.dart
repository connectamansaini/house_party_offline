import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/entrance.dart';

/// The one thing on screen that must be read aloud — a prompt, a question.
/// An "ink" card: the theme's foreground color as the fill, so it's the
/// highest-contrast surface in the app without using any hue. The game's
/// accent appears only on the small eyebrow line.
class PromptCard extends StatelessWidget {
  const PromptCard({
    required this.eyebrow,
    required this.text,
    required this.accent,
    super.key,
  });

  /// Small label above the prompt, e.g. "Round 3 of 10".
  final String eyebrow;

  final String text;

  /// The owning game's accent (see [AppColors.accentOf]).
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // The card inverts the theme, so the eyebrow needs the accent tuned for
    // the *opposite* brightness to stay legible.
    final eyebrowColor = theme.brightness == Brightness.dark
        ? AppColors.legible(accent, Brightness.light)
        : accent;

    return Entrance(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.x7l,
          vertical: Spacing.x8l,
        ),
        decoration: BoxDecoration(
          color: scheme.onSurface,
          borderRadius: BorderRadius.circular(AppRadii.x6l),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                color: eyebrowColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: Spacing.x4l),
            Text(
              text,
              style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                color: scheme.surface,
                fontSize: 22,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
