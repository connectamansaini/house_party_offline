import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/widgets/selectable_player_tile.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_bloc.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_event.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_state.dart';

/// The group votes one player out. Single highlight, confirm to resolve.
class VotingView extends StatelessWidget {
  const VotingView({required this.state, super.key});

  final Voting state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final players = state.session.players;
    final selected = state.selectedId;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
          child: Column(
            children: [
              Text(
                "Who's the imposter?",
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Tap your suspect, then confirm the vote.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            itemCount: players.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = players[i];
              return SelectablePlayerTile(
                name: p.name,
                selected: p.id == selected,
                onTap: () => context.read<GameBloc>().add(VoteSelected(p.id)),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8 + MediaQuery.of(context).padding.bottom,
          ),
          child: FilledButton.icon(
            onPressed: selected == null
                ? null
                : () => context.read<GameBloc>().add(const VoteConfirmed()),
            icon: const Icon(Icons.gavel_rounded),
            label: Text(
              selected == null
                  ? 'Select a player'
                  : 'Vote out '
                        '${players.firstWhere((p) => p.id == selected).name}',
            ),
          ),
        ),
      ],
    );
  }
}
