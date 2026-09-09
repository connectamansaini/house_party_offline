import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/app_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/entrance.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';

/// Landing screen for Most Likely To: start a match or read the rules.
class MostLikelyToHomePage extends StatelessWidget {
  const MostLikelyToHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, Spacing.x7l),
          children: [
            const Entrance(
              child: HeroBanner(
                title: AppStrings.mostLikelyToName,
                subtitle: AppStrings.mostLikelyToBlurb,
                icon: Icons.how_to_vote_rounded,
                gradient: AppColors.spotlightGradient,
              ),
            ),
            const SizedBox(height: Spacing.x5l),
            Entrance(
              index: 1,
              child: TicketCard(
                icon: Icons.play_arrow_rounded,
                title: 'New game',
                subtitle: 'Set up players and rounds',
                gradient: AppColors.spotlightGradient,
                onTap: () => context.push(AppRoutes.mostLikelyToSetup),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Entrance(
              index: 2,
              child: TicketCard(
                icon: Icons.menu_book_rounded,
                title: 'How to play',
                subtitle: 'Rules and how a round works',
                onTap: () => context.push(AppRoutes.mostLikelyToRules),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
