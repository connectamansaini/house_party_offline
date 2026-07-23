import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/hero_banner.dart';

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
            _Section(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'Every player secretly gets the same word — except the '
                  'imposter(s), who get nothing (or just a category hint). '
                  'Civilians try to unmask the imposter; the imposter tries to '
                  'blend in — or, if caught, to guess the secret word and steal '
                  'the win.',
            ),
            _Section(
              icon: Icons.people_alt_rounded,
              title: 'Setup',
              body:
                  'Add everyone (3–12 players) and pick one or more word packs. '
                  'On Start, pass the phone around: each player privately taps '
                  'to see their role, then hides it and passes on.',
            ),
            _NumberedSection(
              icon: Icons.route_rounded,
              title: 'A round, step by step',
              steps: [
                'Reveal: pass the phone so everyone secretly sees their role.',
                'Clues: going around, each player says ONE word related to the '
                    'secret word — no rhymes, spellings, translations, or the '
                    'word itself.',
                'Debate: talk it out before the timer runs down. Who was vague? '
                    'Who was a beat too slow?',
                'Vote: as a shared vote or a secret ballot, the group eliminates '
                    'one suspect.',
                'Last Chance Guess: if the eliminated player is an imposter, '
                    'they get one guess at the secret word to steal the win.',
              ],
            ),
            _Section(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'Civilians win by voting out an imposter and denying their '
                  'guess. The imposter wins by surviving the vote — or by '
                  'guessing the secret word after being caught. The winning side '
                  'banks points each round; play as many rounds as you like.',
            ),
            _BulletSection(
              icon: Icons.tune_rounded,
              title: 'Host options',
              bullets: [
                'Imposters: 1 up to (players − 1).',
                'Imposter gets: nothing, or a decoy word (Undercover) from the '
                    'same category to blend in.',
                'Category hint: optionally tell the imposter the word’s category.',
                'Secret voting: one shared vote, or a private pass-and-play '
                    'ballot that’s tallied.',
                'Discussion length and win points per side.',
              ],
            ),
            _Section(
              icon: Icons.handshake_rounded,
              title: 'Fair play',
              body:
                  'Keep the phone face-down when it isn’t your turn, give exactly '
                  'one word per clue, and never say the secret word out loud. '
                  'No peeking at another player’s reveal!',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _Card(
      icon: icon,
      title: title,
      child: Text(
        body,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.icon,
    required this.title,
    required this.bullets,
  });

  final IconData icon;
  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Card(
      icon: icon,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final b in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: theme.textTheme.bodyMedium),
                  Expanded(
                    child: Text(
                      b,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NumberedSection extends StatelessWidget {
  const _NumberedSection({
    required this.icon,
    required this.title,
    required this.steps,
  });

  final IconData icon;
  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return _Card(
      icon: icon,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: Text(
                      '${i + 1}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        steps[i],
                        style:
                            theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.icon, required this.title, required this.child});

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Text(title, style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
