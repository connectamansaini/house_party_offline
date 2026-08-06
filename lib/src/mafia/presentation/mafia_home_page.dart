import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/hero_banner.dart';

/// Landing screen for the Mafia game: start a match or read the rules.
class MafiaHomePage extends StatelessWidget {
  const MafiaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const HeroBanner(
              title: AppStrings.mafiaName,
              subtitle: AppStrings.mafiaBlurb,
              icon: Icons.dangerous_rounded,
              gradient: AppColors.mafiaGradient,
            ),
            const SizedBox(height: 24),
            _MenuCard(
              icon: Icons.play_arrow_rounded,
              title: 'New game',
              subtitle: 'Set up players and roles',
              highlighted: true,
              onTap: () => context.push(Routes.mafiaSetup),
            ),
            const SizedBox(height: 12),
            _MenuCard(
              icon: Icons.menu_book_rounded,
              title: 'How to play',
              subtitle: 'Roles, night/day flow, and tips',
              onTap: () => context.push(Routes.mafiaRules),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = highlighted ? scheme.onPrimary : scheme.onSurface;
    final subFg = highlighted
        ? scheme.onPrimary.withValues(alpha: 0.85)
        : scheme.onSurfaceVariant;

    return Card(
      color: highlighted ? scheme.primary : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: highlighted
                      ? scheme.onPrimary.withValues(alpha: 0.18)
                      : scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon,
                    size: 28,
                    color:
                        highlighted ? scheme.onPrimary : scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleLarge?.copyWith(color: fg)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(color: subFg)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: subFg),
            ],
          ),
        ),
      ),
    );
  }
}
