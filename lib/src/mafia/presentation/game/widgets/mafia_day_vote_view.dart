import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../mafia_game_bloc.dart';
import '../mafia_game_event.dart';
import '../mafia_game_state.dart';
import 'mafia_player_tile.dart';

/// Daytime lynch: a shared vote with a skip option.
class MafiaDayVoteView extends StatelessWidget {
  const MafiaDayVoteView({super.key, required this.state});

  final MafiaDayVote state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<MafiaGameBloc>();
    final living = state.session.livingPlayers;
    final selected = state.selectedId;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
          child: Column(
            children: [
              Text('Day ${state.session.nightNumber}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
              const SizedBox(height: 2),
              Text('Who do you lynch?', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Discuss, then vote as a group — or skip the day.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            children: [
              for (final p in living)
                MafiaPlayerTile(
                  player: p,
                  selected: p.id == selected,
                  onTap: () => bloc.add(DayTargetSelected(p.id)),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8 + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => bloc.add(const DaySkipped()),
                  child: const Text('Skip day'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: selected == null
                      ? null
                      : () => bloc.add(const DayVoteConfirmed()),
                  icon: const Icon(Icons.gavel_rounded),
                  label: Text(
                    selected == null
                        ? 'Select a player'
                        : 'Lynch ${living.firstWhere((p) => p.id == selected).name}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
