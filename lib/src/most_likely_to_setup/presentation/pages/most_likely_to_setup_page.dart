import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/bloc/most_likely_to_setup_bloc.dart';

/// Setup for a Most Likely To match: roster and round count, then start.
class MostLikelyToSetupPage extends StatelessWidget {
  const MostLikelyToSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MostLikelyToSetupBloc(),
      child: const _SetupView(),
    );
  }
}

class _SetupView extends StatelessWidget {
  const _SetupView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientScaffold(
      appBar: AppBar(title: const Text('New game')),
      body: BlocBuilder<MostLikelyToSetupBloc, MostLikelyToSetupState>(
        builder: (context, state) {
          final bloc = context.read<MostLikelyToSetupBloc>();
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: AppPadding.page,
                    children: [
                      Text('Players', style: theme.textTheme.titleLarge),
                      const SizedBox(height: Spacing.xl),
                      for (var i = 0; i < state.players.length; i++)
                        _PlayerRow(
                          key: ValueKey(state.players[i].id),
                          number: i + 1,
                          player: state.players[i],
                          canRemove:
                              state.players.length >
                              MostLikelyToConfig.minPlayers,
                          onChanged: (name) => bloc.add(
                            MostLikelyToSetupPlayerRenamed(
                              id: state.players[i].id,
                              name: name,
                            ),
                          ),
                          onRemove: () => bloc.add(
                            MostLikelyToSetupPlayerRemoved(
                              state.players[i].id,
                            ),
                          ),
                        ),
                      const SizedBox(height: Spacing.md),
                      if (state.players.length < MostLikelyToConfig.maxPlayers)
                        OutlinedButton.icon(
                          onPressed: () => bloc.add(
                            const MostLikelyToSetupPlayerAdded(),
                          ),
                          icon: const Icon(Icons.person_add_alt),
                          label: const Text('Add player'),
                        ),
                      if (!state.hasEnoughPlayers)
                        Padding(
                          padding: const EdgeInsets.only(top: Spacing.lg),
                          child: Text(
                            'Need at least '
                            '${MostLikelyToConfig.minPlayers} players.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      const Divider(),
                      Text('Options', style: theme.textTheme.titleLarge),
                      const SizedBox(height: Spacing.md),
                      _CountRow(
                        label: 'Rounds',
                        value: state.config.roundCount,
                        min: MostLikelyToConfig.minRounds,
                        max: MostLikelyToConfig.maxRounds,
                        onChanged: (count) => bloc.add(
                          MostLikelyToSetupRoundCountChanged(count),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    Spacing.md,
                    20,
                    Spacing.md + MediaQuery.of(context).padding.bottom,
                  ),
                  child: FilledButton.icon(
                    onPressed: state.canStart
                        ? () => context.push(
                            AppRoutes.mostLikelyToGame,
                            extra: state.buildSetup(),
                          )
                        : null,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start game'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlayerRow extends StatefulWidget {
  const _PlayerRow({
    required this.number,
    required this.player,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final int number;
  final MostLikelyToPlayer player;
  final bool canRemove;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  @override
  State<_PlayerRow> createState() => _PlayerRowState();
}

class _PlayerRowState extends State<_PlayerRow> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.player.name,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.xl),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            child: Text(
              '${widget.number}',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: Spacing.xl),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: 'Player ${widget.number}',
                contentPadding: AppPadding.section,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          const SizedBox(width: Spacing.xs),
          IconButton(
            tooltip: 'Remove',
            visualDensity: VisualDensity.compact,
            onPressed: widget.canRemove ? widget.onRemove : null,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.v4,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          IconButton.filledTonal(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton.filledTonal(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
