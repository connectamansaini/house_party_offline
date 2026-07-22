import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game_bloc.dart';
import '../game_event.dart';
import '../game_state.dart';

/// The group votes one player out. Single highlight, confirm to resolve.
class VotingView extends StatelessWidget {
  const VotingView({super.key, required this.state});

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
              Text("Who's the imposter?", style: theme.textTheme.headlineMedium),
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
              final isSelected = p.id == selected;
              return Card(
                color: isSelected ? scheme.primary : scheme.surfaceContainerHigh,
                child: InkWell(
                  onTap: () =>
                      context.read<GameBloc>().add(VoteSelected(p.id)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: isSelected
                              ? scheme.onPrimary.withValues(alpha: 0.2)
                              : scheme.primaryContainer,
                          foregroundColor: isSelected
                              ? scheme.onPrimary
                              : scheme.onPrimaryContainer,
                          child: Text(
                            p.name.trim().isEmpty
                                ? '?'
                                : p.name.trim()[0].toUpperCase(),
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            p.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isSelected ? scheme.onPrimary : scheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: isSelected
                              ? scheme.onPrimary
                              : scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
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
                  : 'Vote out ${players.firstWhere((p) => p.id == selected).name}',
            ),
          ),
        ),
      ],
    );
  }
}
