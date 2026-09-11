import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/pressable.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';
import 'package:house_party_offline/src/home/presentation/widgets/game_art.dart';

/// The hub's headline slot for the game the host is most likely to want
/// next, with a one-tap shortcut straight into setup. Tapping the card
/// itself opens the game's landing. With key art the card is the picture
/// under a scrim; without, it is an "ink" card (the theme foreground as
/// fill).
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
    final art = game.image;
    // Over art the card is always dark; otherwise it inverts the theme, so
    // the "other side" of the scheme is the ink.
    final ink = art != null ? Colors.white : scheme.surface;
    final inkOn = art != null ? Colors.black : scheme.onSurface;
    final eyebrowColor = art != null || theme.brightness == Brightness.dark
        ? AppColors.legible(accent, Brightness.dark)
        : accent;
    final radius = BorderRadius.circular(AppRadii.x6l);

    return Pressable(
      child: Material(
        color: art != null ? AppColors.artBase : scheme.onSurface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (art != null) Positioned.fill(child: GameArt(image: art)),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onOpen,
                borderRadius: radius,
                splashColor: ink.withValues(alpha: 0.08),
                highlightColor: ink.withValues(alpha: 0.04),
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
                            color: ink.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                      // Art gets room to breathe before the title.
                      SizedBox(height: art != null ? Spacing.x8l : Spacing.x4l),
                      Text(
                        game.title,
                        style: const TextStyle(fontFamily: 'Unbounded')
                            .copyWith(
                              color: ink,
                              fontSize: 26,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(
                        '${game.playersLabel} players · ~${game.minutes} min',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ink.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: Spacing.x5l),
                      FilledButton.icon(
                        onPressed: onPlay,
                        style: FilledButton.styleFrom(
                          backgroundColor: ink,
                          foregroundColor: inkOn,
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
          ],
        ),
      ),
    );
  }
}
