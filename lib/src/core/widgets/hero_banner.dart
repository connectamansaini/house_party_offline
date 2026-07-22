import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A bold gradient banner for the top of a screen — an icon, a title, and an
/// optional subtitle sitting on a vivid brand gradient.
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.title,
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, compact ? 20 : 28, 24, compact ? 20 : 28),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.onGradient, size: 28),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: (compact ? theme.textTheme.headlineSmall : theme.textTheme.headlineLarge)
                ?.copyWith(color: AppColors.onGradient),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.onGradient.withValues(alpha: 0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
