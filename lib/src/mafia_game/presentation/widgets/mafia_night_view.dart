import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_player_tile.dart';

/// Pass-and-play night. Each living player takes the phone; acting roles pick a
/// target, villagers just pass — so nobody can tell who acted.
class MafiaNightView extends StatelessWidget {
  const MafiaNightView({required this.state, super.key});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    if (!state.isRevealed) return _Cover(state: state);
    return _Action(state: state);
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.state});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final player = state.currentPlayer;
    final total = state.session.livingPlayers.length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Night ${state.session.nightNumber} • '
            '${state.currentIndex + 1} of $total',
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
                        Icons.nightlight_round,
                        size: 64,
                        color: scheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'The town sleeps.',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pass to ${player.name}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () =>
                context.read<MafiaGameBloc>().add(const NightActorRevealed()),
            icon: const Icon(Icons.visibility),
            label: Text("I'm ${player.name}"),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.state});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    // Detective result screen.
    if (state.investigationReveal != null) {
      return _Investigation(text: state.investigationReveal!);
    }
    return switch (state.currentRole) {
      MafiaRole.villager => _Asleep(state: state),
      MafiaRole.mafia => _TargetPicker(
        state: state,
        title: 'Mafia — choose tonight’s victim',
        subtitle: _teammateLine(state),
        candidates: state.session.livingPlayers
            .where((p) => !state.session.roleOf(p.id).isMafia)
            .toList(),
        confirmLabel: 'Confirm kill',
      ),
      MafiaRole.doctor => _TargetPicker(
        state: state,
        title: 'Doctor — choose who to protect',
        subtitle: 'They survive the mafia tonight.',
        candidates: state.session.livingPlayers
            .where(
              (p) =>
                  state.session.config.doctorSelfSave ||
                  p.id != state.currentPlayer.id,
            )
            .toList(),
        confirmLabel: 'Confirm protection',
      ),
      MafiaRole.detective => _TargetPicker(
        state: state,
        title: 'Detective — investigate someone',
        subtitle: 'Learn where their loyalty lies.',
        candidates: state.session.livingPlayers
            .where((p) => p.id != state.currentPlayer.id)
            .toList(),
        confirmLabel: 'Investigate',
      ),
    };
  }

  String _teammateLine(MafiaNight state) {
    final mates = state.session.mafiaTeammateNames(state.currentPlayer.id);
    return mates.isEmpty
        ? 'Choose a townsperson to eliminate.'
        : 'With: ${mates.join(', ')}';
  }
}

class _Asleep extends StatelessWidget {
  const _Asleep({required this.state});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('😴', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  Text(
                    'You sleep soundly',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No night powers tonight. Hide the screen and pass on.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () =>
                context.read<MafiaGameBloc>().add(const NightActionConfirmed()),
            icon: const Icon(Icons.visibility_off),
            label: const Text('Hide & pass'),
          ),
        ],
      ),
    );
  }
}

class _Investigation extends StatelessWidget {
  const _Investigation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text('Investigation', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => context.read<MafiaGameBloc>().add(
              const NightInvestigationSeen(),
            ),
            icon: const Icon(Icons.visibility_off),
            label: const Text('Got it — hide & pass'),
          ),
        ],
      ),
    );
  }
}

class _TargetPicker extends StatelessWidget {
  const _TargetPicker({
    required this.state,
    required this.title,
    required this.subtitle,
    required this.candidates,
    required this.confirmLabel,
  });

  final MafiaNight state;
  final String title;
  final String subtitle;
  final List<MafiaPlayer> candidates;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<MafiaGameBloc>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
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
              for (final p in candidates)
                MafiaPlayerTile(
                  player: p,
                  selected: p.id == state.selectedId,
                  onTap: () => bloc.add(NightTargetSelected(p.id)),
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
          child: FilledButton(
            onPressed: state.selectedId == null
                ? null
                : () => bloc.add(const NightActionConfirmed()),
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
