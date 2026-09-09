import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/pressable.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';

/// The hub's headline slot: an "ink" card (the theme foreground as fill) for
/// the game the host is most likely to want next, with a one-tap shortcut
/// straight into setup. Tapping the card itself opens the game's landing.
class FeaturedGameCard extends StatelessWidget {
  const FeaturedGameCard({
    required this.game,
    required this.isRecent,
    required this.onOpen,
    required this.onPlay,
    super.key,
  });

  final HomeGame game;

  /// True when [game] is the last one played (vs. a first-run suggestion).
  final bool isRecent;
  final VoidCallback onOpen;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(game.gradient);
    // The card inverts the theme, so tune the accent for the other side.
    final eyebrowColor = theme.brightness == Brightness.dark
        ? AppColors.legible(accent, Brightness.light)
        : accent;
    final radius = BorderRadius.circular(AppRadii.x6l);

    return Pressable(
      child: Material(
        color: scheme.onSurface,
        borderRadius: radius,
        child: InkWell(
          onTap: onOpen,
          borderRadius: radius,
          splashColor: scheme.surface.withValues(alpha: 0.08),
          highlightColor: scheme.surface.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.x6l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isRecent ? 'JUMP BACK IN' : 'START HERE',
                        style: const TextStyle(fontFamily: 'Unbounded')
                            .copyWith(
                              color: eyebrowColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.6,
                            ),
                      ),
                    ),
                    Icon(
                      game.icon,
                      size: 22,
                      color: scheme.surface.withValues(alpha: 0.7),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.x4l),
                Text(
                  game.title,
                  style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                    color: scheme.surface,
                    fontSize: 26,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  '${game.playersLabel} players · ~${game.minutes} min',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.surface.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: Spacing.x5l),
                FilledButton.icon(
                  onPressed: onPlay,
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.surface,
                    foregroundColor: scheme.onSurface,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(isRecent ? 'Play again' : 'Set up a game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
