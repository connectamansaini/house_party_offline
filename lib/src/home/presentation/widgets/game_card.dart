import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/pressable.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';
import 'package:house_party_offline/src/home/presentation/widgets/game_art.dart';

/// A grid tile for one game: category label, title, and a meta line with
/// the player range and rough length — the facts a host needs to pick a
/// game for the room. Games with key art get it as a full-bleed backdrop
/// with white text over a scrim; the rest show an accent icon chip on the
/// theme's card surface.
class GameCard extends StatelessWidget {
  const GameCard({required this.game, required this.onTap, super.key});

  final HomeGame game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(game.gradient);
    final art = game.image;
    // Over art the card is always dark, whatever the theme.
    final accentInk = AppColors.legible(
      accent,
      art != null ? Brightness.dark : theme.brightness,
    );
    final ink = art != null ? Colors.white : scheme.onSurface;
    final inkMuted = art != null
        ? Colors.white.withValues(alpha: 0.72)
        : scheme.onSurfaceVariant;
    final radius = BorderRadius.circular(AppRadii.x5l);
    final meta = theme.textTheme.bodySmall?.copyWith(color: inkMuted);

    return Pressable(
      child: Material(
        color: art != null ? AppColors.artBase : scheme.surfaceContainerLow,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: art != null
              ? BorderSide.none
              : BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (art != null) GameArt(image: art),
            // A transparent Material above the art so the ink splash paints
            // over the picture instead of underneath it.
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                splashColor: art != null
                    ? Colors.white.withValues(alpha: 0.1)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.x3l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (art == null)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.tint(accent, scheme),
                            borderRadius: BorderRadius.circular(AppRadii.xl),
                          ),
                          child: Icon(game.icon, size: 20, color: accentInk),
                        ),
                      const Spacer(),
                      Text(
                        game.tag.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accentInk,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        game.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Unbounded')
                            .copyWith(
                              color: ink,
                              fontSize: 15,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: Spacing.md),
                      // Wraps to a second line at large text sizes.
                      Wrap(
                        spacing: Spacing.lg,
                        runSpacing: Spacing.xs,
                        children: [
                          _Meta(
                            icon: Icons.people_alt_outlined,
                            text: game.playersLabel,
                            style: meta,
                          ),
                          _Meta(
                            icon: Icons.schedule_rounded,
                            text: '~${game.minutes} min',
                            style: meta,
                          ),
                        ],
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

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, required this.style});

  final IconData icon;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: style?.color),
        const SizedBox(width: Spacing.xs),
        Flexible(child: Text(text, style: style)),
      ],
    );
  }
}
