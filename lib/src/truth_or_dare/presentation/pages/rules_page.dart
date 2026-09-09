import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/rules_sections.dart';

// Multi-line adjacent strings inside a list literal read as ambiguous list
// syntax to the linter, so longer steps live in constants.
const _faceItStep =
    'Read the prompt out loud, then go through with it in front of '
    'everyone.';
const _resolveStep =
    'Tap Done to take the point, or Skip to pass — no point, no shame.';
const _spiceOption =
    'Spice level: Mild keeps it friendly; Spicy adds cheekier prompts on '
    'top.';

/// In-app rulebook for Truth or Dare.
class TruthOrDareRulesPage extends StatelessWidget {
  const TruthOrDareRulesPage({super.key});

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
              subtitle: 'Truth or dare, one turn at a time — the bold win.',
              icon: Icons.menu_book_rounded,
              gradient: AppColors.dareGradient,
              compact: true,
            ),
            SizedBox(height: 20),
            RuleSection(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'Players take turns choosing truth or dare and facing '
                  'whatever the app draws. Going through with it earns a '
                  'point; skipping earns nothing. After the last round, the '
                  'most daring player wins.',
            ),
            RuleSection(
              icon: Icons.people_alt_rounded,
              title: 'Setup',
              body:
                  'Add everyone (2–12 players), choose how many rounds to '
                  'play — every player gets one turn per round — and pick a '
                  'spice level. The whole group plays from one shared screen.',
            ),
            RuleNumberedSection(
              icon: Icons.route_rounded,
              title: 'A turn, step by step',
              steps: [
                'The app says whose turn it is.',
                'They choose Truth or Dare.',
                _faceItStep,
                _resolveStep,
              ],
            ),
            RuleSection(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'Once every round is played, the highest score wins. If '
                  "the top score is shared, it's a tie.",
            ),
            RuleBulletSection(
              icon: Icons.tune_rounded,
              title: 'Host options',
              bullets: ['Rounds: 1 up to 10.', _spiceOption],
            ),
          ],
        ),
      ),
    );
  }
}
