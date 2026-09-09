import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/rules_sections.dart';

// Multi-line adjacent strings inside a list literal read as ambiguous list
// syntax to the linter, so longer steps live in constants.
const _holdStep =
    'Hold the phone on your forehead with the screen facing the room — '
    "you can't see the word, everyone else can.";
const _clueStep =
    'The room shouts clues. Tilt the phone down (or tap Got it) when you '
    'guess it; tilt up (or tap Pass) to skip.';
const _packsOption =
    'Word packs: any of the bundled packs, plus custom packs you made in '
    'Imposter.';

/// In-app rulebook for Heads Up.
class HeadsUpRulesPage extends StatelessWidget {
  const HeadsUpRulesPage({super.key});

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
              subtitle: 'Phone on your forehead, clues from the room.',
              icon: Icons.menu_book_rounded,
              gradient: AppColors.signalGradient,
              compact: true,
            ),
            SizedBox(height: 20),
            RuleSection(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'Guess as many words as you can before the clock runs out, '
                  'using only the clues the others give you. Most correct '
                  'guesses after the last round wins.',
            ),
            RuleSection(
              icon: Icons.people_alt_rounded,
              title: 'Setup',
              body:
                  'Add everyone (2–12 players), pick the word packs, choose '
                  'how long each turn lasts and how many turns each player '
                  'gets. One phone, passed around.',
            ),
            RuleNumberedSection(
              icon: Icons.route_rounded,
              title: 'A turn, step by step',
              steps: [
                "Tap Start when the app says it's your turn.",
                _holdStep,
                _clueStep,
                "When time's up, hand the phone to the next player.",
              ],
            ),
            RuleSection(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'Every correct guess is a point. Once every round is played, '
                  'the highest total wins; a shared top score is a tie.',
            ),
            RuleBulletSection(
              icon: Icons.tune_rounded,
              title: 'Host options',
              bullets: [
                'Turn length: 30, 60 or 90 seconds.',
                'Turns each: 1 up to 5.',
                _packsOption,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
