import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/entrance.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';

/// The games hub. Lists the available party games; each card carries only
/// its game's accent, and the list rises into place on arrival.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final games = [
      (
        title: AppStrings.imposterName,
        subtitle: AppStrings.imposterBlurb,
        icon: Icons.theater_comedy_outlined,
        gradient: AppColors.imposterGradient,
        route: AppRoutes.imposter,
      ),
      (
        title: AppStrings.mafiaName,
        subtitle: AppStrings.mafiaBlurb,
        icon: Icons.dangerous_outlined,
        gradient: AppColors.mafiaGradient,
        route: AppRoutes.mafia,
      ),
      (
        title: AppStrings.neverHaveIEverName,
        subtitle: AppStrings.neverHaveIEverBlurb,
        icon: Icons.record_voice_over_rounded,
        gradient: AppColors.confessionGradient,
        route: AppRoutes.neverHaveIEver,
      ),
      (
        title: AppStrings.mostLikelyToName,
        subtitle: AppStrings.mostLikelyToBlurb,
        icon: Icons.how_to_vote_rounded,
        gradient: AppColors.spotlightGradient,
        route: AppRoutes.mostLikelyTo,
      ),
    ];

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
            const Entrance(
              child: HeroBanner(
                title: AppStrings.appTitle,
                subtitle: AppStrings.homeTagline,
                icon: Icons.celebration_rounded,
              ),
            ),
            const SizedBox(height: Spacing.x5l),
            Entrance(
              index: 1,
              child: Text(
                'Pick a game',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            for (var i = 0; i < games.length; i++) ...[
              if (i > 0) const SizedBox(height: Spacing.xl),
              Entrance(
                index: i + 2,
                child: TicketCard(
                  title: games[i].title,
                  subtitle: games[i].subtitle,
                  icon: games[i].icon,
                  gradient: games[i].gradient,
                  onTap: () => context.push(games[i].route),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
