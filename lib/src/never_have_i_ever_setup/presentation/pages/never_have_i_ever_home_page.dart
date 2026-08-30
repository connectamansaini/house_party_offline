import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';

/// Landing screen for Never Have I Ever: start a match or read the rules.
class NeverHaveIEverHomePage extends StatelessWidget {
  const NeverHaveIEverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, Spacing.x7l),
          children: [
            const HeroBanner(
              title: AppStrings.neverHaveIEverName,
              subtitle: AppStrings.neverHaveIEverBlurb,
              icon: Icons.record_voice_over_rounded,
              gradient: AppColors.confessionGradient,
            ),
            const SizedBox(height: Spacing.x7l),
            TicketCard(
              icon: Icons.play_arrow_rounded,
              title: 'New game',
              subtitle: 'Set up players and lives',
              gradient: AppColors.confessionGradient,
              onTap: () => context.push(AppRoutes.neverHaveIEverSetup),
            ),
            const SizedBox(height: Spacing.xl),
            TicketCard(
              icon: Icons.menu_book_rounded,
              title: 'How to play',
              subtitle: 'Rules and how a round works',
              onTap: () => context.push(AppRoutes.neverHaveIEverRules),
            ),
          ],
        ),
      ),
    );
  }
}
