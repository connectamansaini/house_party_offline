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

/// Landing screen for the Mafia game: start a match or read the rules.
class MafiaHomePage extends StatelessWidget {
  const MafiaHomePage({super.key});

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
                title: AppStrings.mafiaName,
                subtitle: AppStrings.mafiaBlurb,
                icon: Icons.dangerous_rounded,
                gradient: AppColors.mafiaGradient,
              ),
            ),
            const SizedBox(height: Spacing.x5l),
            Entrance(
              index: 1,
              child: TicketCard(
                icon: Icons.play_arrow_rounded,
                title: 'New game',
                subtitle: 'Set up players and roles',
                gradient: AppColors.mafiaGradient,
                onTap: () => context.push(AppRoutes.mafiaSetup),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            Entrance(
              index: 2,
              child: TicketCard(
                icon: Icons.menu_book_rounded,
                title: 'How to play',
                subtitle: 'Roles, night/day flow, and tips',
                onTap: () => context.push(AppRoutes.mafiaRules),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
