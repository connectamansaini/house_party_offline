import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_scaffold.dart';
import '../../core/widgets/hero_banner.dart';

/// In-app rulebook for the Mafia game.
class MafiaRulesPage extends StatelessWidget {
  const MafiaRulesPage({super.key});

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
              subtitle: 'Town vs Mafia — a game of night kills and daytime lies.',
              icon: Icons.menu_book_rounded,
              gradient: AppColors.mafiaGradient,
              compact: true,
            ),
            SizedBox(height: 20),
            _Section(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'The town tries to eliminate every mafia member; the mafia try '
                  'to outnumber the town. The app is your moderator — no narrator '
                  'needed.',
            ),
            _BulletSection(
              icon: Icons.badge_rounded,
              title: 'Roles',
              bullets: [
                'Mafia — secretly kill one player each night. They know each other.',
                'Doctor — each night, protect one player from being killed.',
                'Detective — each night, investigate one player to learn their role.',
                'Villagers — no night powers; use logic and discussion by day.',
              ],
            ),
            _NumberedSection(
              icon: Icons.nightlight_round,
              title: 'Each night',
              steps: [
                'The phone passes to every living player in turn.',
                'Mafia pick a victim, the doctor picks someone to protect, the '
                    'detective investigates — villagers just see a “you sleep” '
                    'screen, so nobody can tell who acted.',
                'The app resolves the night: the victim dies unless the doctor '
                    'protected them.',
              ],
            ),
            _NumberedSection(
              icon: Icons.wb_sunny_rounded,
              title: 'Each day',
              steps: [
                'The app announces who died overnight.',
                'Everyone debates who the mafia might be.',
                'The town votes to lynch one suspect — or skips the day.',
              ],
            ),
            _Section(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'The town wins the moment the last mafia is eliminated. The '
                  'mafia win once they equal the number of remaining townsfolk. '
                  'The game ends immediately and all roles are revealed.',
            ),
            _BulletSection(
              icon: Icons.tune_rounded,
              title: 'Host options',
              bullets: [
                'Number of mafia.',
                'Reveal a player’s role when they die, or keep it secret.',
                'Whether the first night has a kill.',
                'Whether the doctor may protect themselves.',
                'Whether the detective learns the exact role or just mafia/not.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.body});

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
                    child: Text(b,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(height: 1.35)),
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
                    child: Text('${i + 1}',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(steps[i],
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(height: 1.35)),
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
