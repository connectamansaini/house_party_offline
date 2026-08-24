import 'package:flutter/material.dart';

import 'package:house_party_offline/src/core/theme/app_colors.dart';

/// A tappable game tile in the hub. Enabled tiles carry a vivid gradient
/// icon badge; disabled tiles read as a dimmed "coming soon" placeholder.
class GameCard extends StatelessWidget {
  const GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
    this.onTap,
    this.trailingLabel,
    this.gradient = AppColors.brandGradient,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final String? trailingLabel;
  final Gradient gradient;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: Card(
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    gradient: enabled ? gradient : null,
                    color: enabled ? null : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: enabled
                        ? [
                            BoxShadow(
                              color: gradient.colors.first.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: enabled
                        ? AppColors.onGradient
                        : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                          if (trailingLabel != null) ...[
                            const SizedBox(width: 8),
                            _Badge(label: trailingLabel!),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (enabled)
                  Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onTertiaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
