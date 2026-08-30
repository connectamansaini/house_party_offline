import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_session.dart';

/// Final screen: the last player standing (or a full wipeout tie).
class NeverHaveIEverGameOverView extends StatelessWidget {
  const NeverHaveIEverGameOverView({required this.session, super.key});

  final NeverHaveIEverSession session;

  @override
  Widget build(BuildContext context) {
    final winner = session.winner;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: MomentCard(
            mood: MomentMood.celebration,
            gradient: AppColors.confessionGradient,
            icon: MomentIcon.laurel,
            headline: winner != null ? '${winner.name} wins!' : "It's a draw!",
            subtitle: winner != null
                ? 'Last one with lives left.'
                : 'Everyone ran out at once.',
          ),
        ),
        const SizedBox(height: Spacing.xl),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Text(
                'Final lives',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: Spacing.md),
              for (final p in session.players)
                Card(
                  child: ListTile(
                    title: Text(p.name),
                    trailing: Text(
                      '${session.lives[p.id] ?? 0} lives',
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
                  onPressed: () => context.go(AppRoutes.neverHaveIEver),
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
}
