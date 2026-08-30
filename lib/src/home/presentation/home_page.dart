import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';

/// The games hub. Lists available party games as vivid cards.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientScaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Spacing.x5l,
            Spacing.x7l,
            Spacing.x5l,
            Spacing.x7l,
          ),
          children: [
            const HeroBanner(
              title: AppStrings.appTitle,
              subtitle: AppStrings.homeTagline,
              icon: Icons.celebration_rounded,
            ),
            const SizedBox(height: Spacing.x7l),
            Text(
              'Pick a game',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Spacing.xl),
            TicketCard(
              title: AppStrings.imposterName,
              subtitle: AppStrings.imposterBlurb,
              icon: Icons.theater_comedy_outlined,
              gradient: AppColors.imposterGradient,
              onTap: () => context.push(AppRoutes.imposter),
            ),
            const SizedBox(height: Spacing.xl),
            TicketCard(
              title: AppStrings.mafiaName,
              subtitle: AppStrings.mafiaBlurb,
              icon: Icons.dangerous_outlined,
              gradient: AppColors.mafiaGradient,
              onTap: () => context.push(AppRoutes.mafia),
            ),
            const SizedBox(height: Spacing.xl),
            TicketCard(
              title: AppStrings.neverHaveIEverName,
              subtitle: AppStrings.neverHaveIEverBlurb,
              icon: Icons.record_voice_over_rounded,
              gradient: AppColors.confessionGradient,
              onTap: () => context.push(AppRoutes.neverHaveIEver),
            ),
          ],
        ),
      ),
    );
  }
}
