import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_session.dart';

/// Final screen: the top guesser (or a shared top score), then the standings.
class HeadsUpGameOverView extends StatelessWidget {
  const HeadsUpGameOverView({required this.session, super.key});

  final HeadsUpSession session;

  @override
  Widget build(BuildContext context) {
    final winner = session.winner;
    final leaders = session.leaders;

    final String headline;
    final String subtitle;
    if (winner != null) {
      headline = '${winner.name} wins!';
      subtitle = 'Fastest head in the room.';
    } else if (leaders.isEmpty) {
      headline = 'Nobody scored!';
      subtitle = 'Tough words, or tough clues.';
    } else {
      headline = "It's a tie!";
      subtitle = leaders.map((p) => p.name).join(', ');
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: MomentCard(
            mood: MomentMood.celebration,
            gradient: AppColors.signalGradient,
            icon: MomentIcon.laurel,
            headline: headline,
            subtitle: subtitle,
          ),
        ),
        const SizedBox(height: Spacing.xl),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Text(
                'Final scores',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: Spacing.md),
              for (final p in session.standings)
                Card(
                  child: ListTile(
                    title: Text(p.name),
                    trailing: Text(
                      _points(session.scores[p.id] ?? 0),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            8 + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.headsUp),
                  child: const Text('Play again'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Games'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _points(int score) => score == 1 ? '1 word' : '$score words';
}
