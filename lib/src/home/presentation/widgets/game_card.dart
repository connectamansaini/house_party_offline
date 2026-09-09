import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/pressable.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';

/// A grid tile for one game: accent icon chip, category label, title, and a
/// meta line with the player range and rough length — the facts a host
/// needs to pick a game for the room.
class GameCard extends StatelessWidget {
  const GameCard({required this.game, required this.onTap, super.key});

  final HomeGame game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(game.gradient);
    final accentInk = AppColors.legible(accent, theme.brightness);
    final radius = BorderRadius.circular(AppRadii.x5l);
    final meta = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Pressable(
      child: Material(
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.x3l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                    color: scheme.onSurface,
                    fontSize: 15,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(game.playersLabel, style: meta),
                    const SizedBox(width: Spacing.lg),
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text('~${game.minutes} min', style: meta),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
