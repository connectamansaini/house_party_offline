import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/home/presentation/widgets/game_card.dart';

/// The games hub. Lists available party games as vivid cards.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientScaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
          children: [
            Row(
              children: [
                Text('🎉', style: theme.textTheme.displaySmall),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appTitle,
                        style: theme.textTheme.headlineLarge,
                      ),
                      Text(
                        AppStrings.homeTagline,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Pick a game',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            GameCard(
              title: AppStrings.imposterName,
              subtitle: AppStrings.imposterBlurb,
              icon: Icons.theater_comedy_outlined,
              gradient: AppColors.imposterGradient,
              onTap: () => context.push(AppRoutes.imposter),
            ),
            const SizedBox(height: 12),
            GameCard(
              title: AppStrings.mafiaName,
              subtitle: AppStrings.mafiaBlurb,
              icon: Icons.dangerous_outlined,
              gradient: AppColors.mafiaGradient,
              onTap: () => context.push(AppRoutes.mafia),
            ),
            const SizedBox(height: 12),
            const GameCard(
              title: 'More games',
              subtitle: 'New party games are on the way.',
              icon: Icons.add_reaction_outlined,
              trailingLabel: AppStrings.comingSoon,
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
