import 'package:flutter/material.dart';

import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';

/// The top of a screen: a small accent-tinted icon, a large title, and an
/// optional subtitle — set directly on the page background, no box. The
/// [gradient] is kept for call-site compatibility and only supplies the
/// accent (see [AppColors.accentOf]).
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.gradient = AppColors.brandGradient,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Gradient gradient;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(gradient);
    final chip = compact ? 40.0 : 52.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? Spacing.md : Spacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: chip,
              height: chip,
              decoration: BoxDecoration(
                color: AppColors.tint(accent, scheme),
                borderRadius: BorderRadius.circular(AppRadii.x3l),
              ),
              child: Icon(
                icon,
                color: AppColors.legible(accent, theme.brightness),
                size: compact ? 20 : 26,
              ),
            ),
            SizedBox(height: compact ? Spacing.xl : Spacing.x5l),
          ],
          Text(
            title,
            style:
                (compact
                        ? theme.textTheme.headlineSmall
                        : theme.textTheme.headlineLarge)
                    ?.copyWith(color: scheme.onSurface),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: Spacing.sm),
            Text(
              subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
