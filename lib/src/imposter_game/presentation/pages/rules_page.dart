import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/rules_sections.dart';

// Long copy for the numbered/bulleted lists below. Pulled out to top-level
// constants (rather than wrapped inline) because a multi-line adjacent-string
// list *element* reads as ambiguous list syntax — one item or two? — so the
// linter requires each item to be a single expression.
const _clueStep =
    'Clues: going around, each player says ONE word related to the secret '
    'word — no rhymes, spellings, translations, or the word itself.';
const _debateStep =
    'Debate: talk it out before the timer runs down. Who was vague? Who '
    'was a beat too slow?';
const _voteStep =
    'Vote: as a shared vote or a secret ballot, the group eliminates one '
    'suspect.';
const _guessStep =
    'Last Chance Guess: if the eliminated player is an imposter, they get '
    'one guess at the secret word to steal the win.';

const _imposterGetsBullet =
    'Imposter gets: nothing, or a decoy word (Undercover) from the same '
    'category to blend in.';
const _secretVotingBullet =
    'Secret voting: one shared vote, or a private pass-and-play ballot '
    'that’s tallied.';
const _categoryHintBullet =
    'Category hint: optionally tell the imposter the word’s category.';

/// In-app rulebook for the Imposter game.
class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

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
              subtitle: 'Everyone knows the word — except the imposter.',
              icon: Icons.menu_book_rounded,
              gradient: AppColors.imposterGradient,
              compact: true,
            ),
            SizedBox(height: 20),
            RuleSection(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'Every player secretly gets the same word — except the '
                  'imposter(s), who get nothing (or just a category hint). '
                  'Civilians try to unmask the imposter; the imposter '
                  'tries to blend in — or, if caught, to guess the secret '
                  'word and steal the win.',
            ),
            RuleSection(
              icon: Icons.people_alt_rounded,
              title: 'Setup',
              body:
                  'Add everyone (3–12 players) and pick one or more word '
                  'packs. On Start, pass the phone around: each player '
                  'privately taps to see their role, then hides it and '
                  'passes on.',
            ),
            RuleNumberedSection(
              icon: Icons.route_rounded,
              title: 'A round, step by step',
              steps: [
                'Reveal: pass the phone so everyone secretly sees their role.',
                _clueStep,
                _debateStep,
                _voteStep,
                _guessStep,
              ],
            ),
            RuleSection(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'Civilians win by voting out an imposter and denying '
                  'their guess. The imposter wins by surviving the vote '
                  '— or by guessing the secret word after being caught. '
                  'The winning side banks points each round; play as '
                  'many rounds as you like.',
            ),
            RuleBulletSection(
              icon: Icons.tune_rounded,
              title: 'Host options',
              bullets: [
                'Imposters: 1 up to (players − 1).',
                _imposterGetsBullet,
                _categoryHintBullet,
                _secretVotingBullet,
                'Discussion length and win points per side.',
              ],
            ),
            RuleSection(
              icon: Icons.handshake_rounded,
              title: 'Fair play',
              body:
                  'Keep the phone face-down when it isn’t your turn, '
                  'give exactly one word per clue, and never say the '
                  'secret word out loud. No peeking at another player’s '
                  'reveal!',
            ),
          ],
        ),
      ),
    );
  }
}
