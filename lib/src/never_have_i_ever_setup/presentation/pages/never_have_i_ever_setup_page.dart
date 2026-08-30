import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';
import 'package:house_party_offline/src/never_have_i_ever_setup/presentation/bloc/never_have_i_ever_setup_bloc.dart';

/// Setup for a Never Have I Ever match: roster and lives, then start.
class NeverHaveIEverSetupPage extends StatelessWidget {
  const NeverHaveIEverSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NeverHaveIEverSetupBloc(),
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
      body: BlocBuilder<NeverHaveIEverSetupBloc, NeverHaveIEverSetupState>(
        builder: (context, state) {
          final bloc = context.read<NeverHaveIEverSetupBloc>();
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
                              NeverHaveIEverConfig.minPlayers,
                          onChanged: (name) => bloc.add(
                            NeverHaveIEverSetupPlayerRenamed(
                              id: state.players[i].id,
                              name: name,
                            ),
                          ),
                          onRemove: () => bloc.add(
                            NeverHaveIEverSetupPlayerRemoved(
                              state.players[i].id,
                            ),
                          ),
                        ),
                      const SizedBox(height: Spacing.md),
                      if (state.players.length <
                          NeverHaveIEverConfig.maxPlayers)
                        OutlinedButton.icon(
                          onPressed: () => bloc.add(
                            const NeverHaveIEverSetupPlayerAdded(),
                          ),
                          icon: const Icon(Icons.person_add_alt),
                          label: const Text('Add player'),
                        ),
                      if (!state.hasEnoughPlayers)
                        Padding(
                          padding: const EdgeInsets.only(top: Spacing.lg),
                          child: Text(
                            'Need at least '
                            '${NeverHaveIEverConfig.minPlayers} players.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      const Divider(),
                      Text('Options', style: theme.textTheme.titleLarge),
                      const SizedBox(height: Spacing.md),
                      _CountRow(
                        label: 'Lives per player',
                        value: state.config.livesPerPlayer,
                        min: NeverHaveIEverConfig.minLives,
                        max: NeverHaveIEverConfig.maxLives,
                        onChanged: (count) => bloc.add(
                          NeverHaveIEverSetupLivesCountChanged(count),
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
                            AppRoutes.neverHaveIEverGame,
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
  final NeverHaveIEverPlayer player;
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
