import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/rules_sections.dart';

// Long copy for the bulleted/numbered lists below. Pulled out to top-level
// constants (rather than wrapped inline) because a multi-line adjacent-string
// list *element* reads as ambiguous list syntax — one item or two? — so the
// linter requires each item to be a single expression.
const _mafiaRoleBullet =
    'Mafia — secretly kill one player each night. They know each other.';
const _detectiveRoleBullet =
    'Detective — each night, investigate one player to learn their role.';

const _nightActionsStep =
    'Mafia pick a victim, the doctor picks someone to protect, the '
    'detective investigates — villagers just see a “you sleep” screen, '
    'so nobody can tell who acted.';
const _nightResolveStep =
    'The app resolves the night: the victim dies unless the doctor '
    'protected them.';

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
              subtitle:
                  'Town vs Mafia — a game of night kills and daytime lies.',
              icon: Icons.menu_book_rounded,
              gradient: AppColors.mafiaGradient,
              compact: true,
            ),
            SizedBox(height: 20),
            RuleSection(
              icon: Icons.flag_rounded,
              title: 'Objective',
              body:
                  'The town tries to eliminate every mafia member; the '
                  'mafia try to outnumber the town. The app is your '
                  'moderator — no narrator needed.',
            ),
            RuleBulletSection(
              icon: Icons.badge_rounded,
              title: 'Roles',
              bullets: [
                _mafiaRoleBullet,
                'Doctor — each night, protect one player from being killed.',
                _detectiveRoleBullet,
                'Villagers — no night powers; use logic and discussion by day.',
              ],
            ),
            RuleNumberedSection(
              icon: Icons.nightlight_round,
              title: 'Each night',
              steps: [
                'The phone passes to every living player in turn.',
                _nightActionsStep,
                _nightResolveStep,
              ],
            ),
            RuleNumberedSection(
              icon: Icons.wb_sunny_rounded,
              title: 'Each day',
              steps: [
                'The app announces who died overnight.',
                'Everyone debates who the mafia might be.',
                'The town votes to lynch one suspect — or skips the day.',
              ],
            ),
            RuleSection(
              icon: Icons.emoji_events_rounded,
              title: 'Winning',
              body:
                  'The town wins the moment the last mafia is eliminated. '
                  'The mafia win once they equal the number of remaining '
                  'townsfolk. The game ends immediately and all roles are '
                  'revealed.',
            ),
            RuleBulletSection(
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
