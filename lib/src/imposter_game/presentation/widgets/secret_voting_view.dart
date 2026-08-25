import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_bloc.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_event.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_state.dart';

/// Pass-and-play secret ballot: each player privately votes, then the tally
/// (handled by the bloc) decides who is eliminated.
class SecretVotingView extends StatelessWidget {
  const SecretVotingView({required this.state, super.key});

  final SecretVoting state;

  @override
  Widget build(BuildContext context) {
    return state.isVoterReady ? _Ballot(state: state) : _Cover(state: state);
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.state});

  final SecretVoting state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final voter = state.currentVoter;
    final total = state.session.players.length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Vote ${state.currentVoterIndex + 1} of $total',
            style: theme.textTheme.labelLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Center(
              child: Card(
                color: scheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 48,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.how_to_vote_rounded,
                        size: 64,
                        color: scheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Pass the phone to',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        voter.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cast your vote in secret 🤫',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => context.read<GameBloc>().add(const BallotOpened()),
            icon: const Icon(Icons.visibility),
            label: Text("I'm ${voter.name} — vote"),
          ),
        ],
      ),
    );
  }
}

class _Ballot extends StatelessWidget {
  const _Ballot({required this.state});

  final SecretVoting state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final candidates = state.candidates;
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
                '${state.currentVoter.name}, pick in secret.',
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
            itemCount: candidates.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = candidates[i];
              final isSelected = p.id == selected;
              return Card(
                color: isSelected
                    ? scheme.primary
                    : scheme.surfaceContainerHigh,
                child: InkWell(
                  onTap: () =>
                      context.read<GameBloc>().add(BallotSelected(p.id)),
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
                              color: isSelected
                                  ? scheme.onPrimary
                                  : scheme.onSurface,
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
                : () => context.read<GameBloc>().add(const BallotCast()),
            icon: Icon(
              state.isLastVoter ? Icons.gavel_rounded : Icons.arrow_forward,
            ),
            label: Text(
              state.isLastVoter ? 'Cast & reveal result' : 'Cast & pass',
            ),
          ),
        ),
      ],
    );
  }
}
