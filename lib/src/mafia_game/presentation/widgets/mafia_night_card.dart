import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_role_visuals.dart';

/// The header above a night picker, in either mode: the role's mark and
/// colour, the instruction, and an optional chip for the names that matter
/// right now — who is awake for the host, or who you are in it with.
///
/// Sized to leave the list below it room, unlike the full-bleed
/// [MomentCard] used for beats with nothing to tap.
class MafiaNightCard extends StatelessWidget {
  const MafiaNightCard({
    required this.role,
    required this.eyebrow,
    required this.headline,
    required this.subtitle,
    this.chip,
    this.chipIcon = Icons.group_outlined,
    super.key,
  });

  final MafiaRole role;

  /// Small label beside the mark — the role, or what to do with the card.
  final String eyebrow;

  final String headline;
  final String subtitle;

  /// Optional callout: teammates, or who should have their eyes open.
  final String? chip;
  final IconData chipIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final visual = roleVisual(role);
    final accent = AppColors.accentOf(visual.gradient);
    final ink = AppColors.legible(accent, theme.brightness);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.x5l),
      decoration: BoxDecoration(
        color: AppColors.tint(accent, scheme),
        borderRadius: BorderRadius.circular(AppRadii.x5l),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MomentGlyph(icon: visual.icon, size: 22, color: ink),
              const SizedBox(width: Spacing.lg),
              Text(
                eyebrow,
                style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                  color: ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.x3l),
          Text(
            headline,
            style: const TextStyle(fontFamily: 'Unbounded').copyWith(
              color: scheme.onSurface,
              fontSize: 20,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (chip != null) ...[
            const SizedBox(height: Spacing.x3l),
            _Chip(text: chip!, icon: chipIcon, accent: accent),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.icon, required this.accent});

  final String text;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x2l,
        vertical: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: scheme.onSurfaceVariant),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
