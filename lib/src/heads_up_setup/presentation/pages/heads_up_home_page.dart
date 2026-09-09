import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/entrance.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';

/// Landing screen for Heads Up: start a match, manage packs, or read the
/// rules.
class HeadsUpHomePage extends StatelessWidget {
  const HeadsUpHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, Spacing.x7l),
          children: [
            const Entrance(
              child: HeroBanner(
                title: AppStrings.headsUpName,
                subtitle: AppStrings.headsUpBlurb,
                icon: Icons.emoji_people_rounded,
                gradient: AppColors.signalGradient,
              ),
            ),
            const SizedBox(height: Spacing.x5l),
            Entrance(
              index: 1,
              child: TicketCard(
                icon: Icons.play_arrow_rounded,
                title: 'New game',
                subtitle: 'Set up players, packs and the clock',
                gradient: AppColors.signalGradient,
                onTap: () => context.push(AppRoutes.headsUpSetup),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Entrance(
              index: 2,
              child: TicketCard(
                icon: Icons.style_outlined,
                title: 'Word packs',
                subtitle: 'Shared with Imposter — browse or create',
                gradient: AppColors.civilianGradient,
                onTap: () => context.push(AppRoutes.imposterPacks),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Entrance(
              index: 3,
              child: TicketCard(
                icon: Icons.menu_book_rounded,
                title: 'How to play',
                subtitle: 'Rules and how a turn works',
                onTap: () => context.push(AppRoutes.headsUpRules),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
