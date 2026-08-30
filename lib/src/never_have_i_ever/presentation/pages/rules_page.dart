import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/rules_sections.dart';

// A multi-line adjacent-string list *element* reads as ambiguous list
// syntax — one item or two? — so the linter requires each item to be a
// single expression; pulled out to a constant instead.
const _tapMatchesStep =
    'Tap every player who matched — the app docks one life each.';

/// In-app rulebook for Never Have I Ever.
class NeverHaveIEverRulesPage extends StatelessWidget {
  const NeverHaveIEverRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('How to play')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: const [
            HeroBanner(
              title: 'How to play',
              subtitle: 'Confess, or lose a life — last player standing wins.',
              icon: Icons.menu_book_rounded,
              gradient: AppColors.confessionGradient,
              compact: true,
            ),
            SizedBox(height: 20),
            RuleSection(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'Every round the app shows a "Never have I ever..." '
                  'prompt out loud to the group. Anyone who has actually '
                  'done it loses a life. Last player with lives remaining '
                  'wins.',
            ),
            RuleSection(
              icon: Icons.people_alt_rounded,
              title: 'Setup',
              body:
                  'Add everyone (2–12 players) and choose how many lives '
                  'each player starts with. No pass-and-play needed — the '
                  'whole group plays from one shared screen.',
            ),
            RuleNumberedSection(
              icon: Icons.route_rounded,
              title: 'A round, step by step',
              steps: [
                'Read the prompt out loud to the group.',
                'Anyone who has done it says so.',
                _tapMatchesStep,
                'Confirm to move to the next prompt.',
              ],
            ),
            RuleSection(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'A player is out once they hit zero lives. The match ends '
                  'the moment only one player still has lives — they win. '
                  'If the last two players are both eliminated in the same '
                  "round, it's a draw.",
            ),
            RuleBulletSection(
              icon: Icons.tune_rounded,
              title: 'Host options',
              bullets: ['Lives per player: 1 up to 10.'],
            ),
          ],
        ),
      ),
    );
  }
}
