import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/rules_sections.dart';

// Multi-line adjacent strings inside a list literal read as ambiguous list
// syntax to the linter, so longer steps live in constants.
const _pointStep =
    'On the count of three, everyone points at the player they think '
    'fits best.';
const _tapStep =
    'Tap whoever got the most fingers — they take the point. If the vote '
    'tied, tap everyone who tied.';

/// In-app rulebook for Most Likely To.
class MostLikelyToRulesPage extends StatelessWidget {
  const MostLikelyToRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How to play')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: const [
            HeroBanner(
              title: 'How to play',
              subtitle: 'Point fingers, collect points — top score wins.',
              icon: Icons.menu_book_rounded,
              gradient: AppColors.spotlightGradient,
              compact: true,
            ),
            SizedBox(height: 20),
            RuleSection(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'Every round the app shows a "Most likely to..." prompt. '
                  'The whole group points at whoever fits it best, and that '
                  'player scores a point. After the last round, the player '
                  'with the most points wins.',
            ),
            RuleSection(
              icon: Icons.people_alt_rounded,
              title: 'Setup',
              body:
                  'Add everyone (3–12 players) and choose how many rounds to '
                  'play. No pass-and-play needed — the whole group plays '
                  'from one shared screen.',
            ),
            RuleNumberedSection(
              icon: Icons.route_rounded,
              title: 'A round, step by step',
              steps: [
                'Read the prompt out loud to the group.',
                _pointStep,
                _tapStep,
                'Confirm to move to the next prompt.',
              ],
            ),
            RuleSection(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'Nobody is ever out — every player stays in until the last '
                  'round. Once all rounds are played, the highest score wins. '
                  "If the top score is shared, it's a tie.",
            ),
            RuleBulletSection(
              icon: Icons.tune_rounded,
              title: 'Host options',
              bullets: ['Rounds: 3 up to 30.'],
            ),
          ],
        ),
      ),
    );
  }
}
