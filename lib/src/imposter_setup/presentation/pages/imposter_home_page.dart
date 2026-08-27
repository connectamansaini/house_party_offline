import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';

/// Landing screen for the Imposter game: start a game or manage word packs.
class ImposterHomePage extends StatelessWidget {
  const ImposterHomePage({super.key});

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
              title: AppStrings.imposterName,
              subtitle: AppStrings.imposterBlurb,
              icon: Icons.theater_comedy,
              gradient: AppColors.imposterGradient,
            ),
            const SizedBox(height: Spacing.x7l),
            TicketCard(
              icon: Icons.play_arrow_rounded,
              title: 'New game',
              subtitle: 'Set up players and start playing',
              gradient: AppColors.imposterGradient,
              onTap: () => context.push(AppRoutes.imposterSetup),
            ),
            const SizedBox(height: Spacing.xl),
            TicketCard(
              icon: Icons.style_outlined,
              title: 'Word packs',
              subtitle: 'Browse, create, and edit packs',
              gradient: AppColors.civilianGradient,
              onTap: () => context.push(AppRoutes.imposterPacks),
            ),
            const SizedBox(height: Spacing.xl),
            TicketCard(
              icon: Icons.menu_book_rounded,
              title: 'How to play',
              subtitle: 'Rules, round flow, and tips',
              onTap: () => context.push(AppRoutes.imposterRules),
            ),
          ],
        ),
      ),
    );
  }
}
