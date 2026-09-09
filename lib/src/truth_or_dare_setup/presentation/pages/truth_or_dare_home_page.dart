import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/entrance.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/ticket_card.dart';

/// Landing screen for Truth or Dare: start a match or read the rules.
class TruthOrDareHomePage extends StatelessWidget {
  const TruthOrDareHomePage({super.key});

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
                title: AppStrings.truthOrDareName,
                subtitle: AppStrings.truthOrDareBlurb,
                icon: Icons.local_fire_department_rounded,
                gradient: AppColors.dareGradient,
              ),
            ),
            const SizedBox(height: Spacing.x5l),
            Entrance(
              index: 1,
              child: TicketCard(
                icon: Icons.play_arrow_rounded,
                title: 'New game',
                subtitle: 'Set up players, rounds and spice',
                gradient: AppColors.dareGradient,
                onTap: () => context.push(AppRoutes.truthOrDareSetup),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Entrance(
              index: 2,
              child: TicketCard(
                icon: Icons.edit_note_rounded,
                title: 'Your prompts',
                subtitle: 'Add your own truths and dares',
                onTap: () => context.push(AppRoutes.truthOrDarePrompts),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Entrance(
              index: 3,
              child: TicketCard(
                icon: Icons.menu_book_rounded,
                title: 'How to play',
                subtitle: 'Rules and how a turn works',
                onTap: () => context.push(AppRoutes.truthOrDareRules),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
