import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/hero_banner.dart';
import 'package:house_party_offline/src/core/widgets/rules_sections.dart';

// Long copy for the bulleted/numbered lists below. Pulled out to top-level
// constants (rather than wrapped inline) because a multi-line adjacent-string
// list *element* reads as ambiguous list syntax — one item or two? — so the
// linter requires each item to be a single expression.
const _mafiaRoleBullet =
    'Mafia — secretly kill one player each night. They know each other.';
const _doctorRoleBullet =
    'Doctor (optional) — each night, protect one player from being killed.';
const _detectiveRoleBullet =
    'Detective (optional) — each night, investigate one player to learn '
    'their role.';
const _villagerRoleBullet =
    'Villagers — no night powers; use logic and discussion by day.';
const _specialsBullet =
    'Leave the doctor or the detective out at setup for a faster, harsher '
    'game — the night simply skips their turn.';

const _nightActionsStep =
    'Mafia pick a victim, the doctor picks someone to protect, the '
    'detective investigates — villagers just see a “you sleep” screen, '
    'so nobody can tell who acted.';
const _nightResolveStep =
    'The app resolves the night: the victim dies unless the doctor '
    'protected them.';

const _hostPassStep =
    'Pass-and-play — the phone goes round every living player each '
    'night, acting roles and villagers alike.';
const _hostRunStep =
    'Host runs the night — one person narrates and keeps the phone. '
    'Turn it on in setup and pick who hosts; they are dealt no role.';
const _hostRotateStep =
    'Rotate the host to hand the job to the next person on the list each '
    'game, so nobody sits out two nights running. The narrator knows every '
    'role, so they can never also play the game they are running.';

const _hostOptionBullet =
    'Whether a host runs the night, who hosts, and whether the job rotates '
    'between games.';

const _hostScriptStep =
    'The app gives the host a line to read for each role: “Mafia, open '
    'your eyes”, and so on.';
const _hostTapStep =
    'The waking players point at their target with everyone else’s eyes '
    'shut, and the host taps it in.';
const _hostDetectiveStep =
    'For the detective, the host shows them the answer on screen, then '
    'carries on.';

/// In-app rulebook for the Mafia game.
class MafiaRulesPage extends StatelessWidget {
  const MafiaRulesPage({super.key});

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
                  'mafia try to outnumber the town. The app moderates, so '
                  'no one has to keep the secrets straight.',
            ),
            RuleBulletSection(
              icon: Icons.badge_rounded,
              title: 'Roles',
              bullets: [
                _mafiaRoleBullet,
                _doctorRoleBullet,
                _detectiveRoleBullet,
                _villagerRoleBullet,
                _specialsBullet,
              ],
            ),
            RuleBulletSection(
              icon: Icons.campaign_rounded,
              title: 'Two ways to play',
              bullets: [_hostPassStep, _hostRunStep, _hostRotateStep],
            ),
            RuleNumberedSection(
              icon: Icons.nightlight_round,
              title: 'Each night (pass-and-play)',
              steps: [
                'The phone passes to every living player in turn.',
                _nightActionsStep,
                _nightResolveStep,
              ],
            ),
            RuleNumberedSection(
              icon: Icons.record_voice_over_rounded,
              title: 'Each night (with a host)',
              steps: [
                'Everyone closes their eyes; the host keeps the phone.',
                _hostScriptStep,
                _hostTapStep,
                _hostDetectiveStep,
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
              title: 'Match options',
              bullets: [
                _hostOptionBullet,
                'Number of mafia, and whether a doctor and detective play.',
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
