import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';
import 'package:house_party_offline/src/heads_up_setup/presentation/bloc/heads_up_setup_bloc.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';

/// Setup for a Heads Up match: roster, word packs, clock and turns.
class HeadsUpSetupPage extends StatelessWidget {
  const HeadsUpSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeadsUpSetupBloc(
        getIt<RosterRepository>(),
        getIt<GetImposterPacksUseCase>(),
      )..add(const HeadsUpSetupStarted()),
      child: const _SetupView(),
    );
  }
}

class _SetupView extends StatelessWidget {
  const _SetupView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('New game')),
      body: BlocBuilder<HeadsUpSetupBloc, HeadsUpSetupState>(
        builder: (context, state) {
          final bloc = context.read<HeadsUpSetupBloc>();
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
                              state.players.length > HeadsUpConfig.minPlayers,
                          onChanged: (name) => bloc.add(
                            HeadsUpSetupPlayerRenamed(
                              id: state.players[i].id,
                              name: name,
                            ),
                          ),
                          onRemove: () => bloc.add(
                            HeadsUpSetupPlayerRemoved(state.players[i].id),
                          ),
                        ),
                      const SizedBox(height: Spacing.md),
                      if (state.players.length < HeadsUpConfig.maxPlayers)
                        OutlinedButton.icon(
                          onPressed: () =>
                              bloc.add(const HeadsUpSetupPlayerAdded()),
                          icon: const Icon(Icons.person_add_alt),
                          label: const Text('Add player'),
                        ),
                      const Divider(),
                      Text('Word packs', style: theme.textTheme.titleLarge),
                      const SizedBox(height: Spacing.md),
                      _PacksSection(state: state),
                      const Divider(),
                      Text('Options', style: theme.textTheme.titleLarge),
                      const SizedBox(height: Spacing.md),
                      Padding(
                        padding: AppPadding.v4,
                        child: Row(
                          children: [
                            const Expanded(child: Text('Turn length')),
                            SegmentedButton<int>(
                              showSelectedIcon: false,
                              segments: [
                                for (final s in HeadsUpConfig.secondsOptions)
                                  ButtonSegment(value: s, label: Text('${s}s')),
                              ],
                              selected: {state.config.roundSeconds},
                              onSelectionChanged: (selection) => bloc.add(
                                HeadsUpSetupRoundSecondsChanged(
                                  selection.first,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _CountRow(
                        label: 'Turns each',
                        value: state.config.roundCount,
                        min: HeadsUpConfig.minRounds,
                        max: HeadsUpConfig.maxRounds,
                        onChanged: (count) =>
                            bloc.add(HeadsUpSetupRoundCountChanged(count)),
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
                        ? () {
                            bloc.add(const HeadsUpSetupRosterSaved());
                            context.push(
                              AppRoutes.headsUpGame,
                              extra: state.buildSetup(),
                            );
                          }
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

class _PacksSection extends StatelessWidget {
  const _PacksSection({required this.state});

  final HeadsUpSetupState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<HeadsUpSetupBloc>();

    switch (state.packsStatus) {
      case HeadsUpPacksStatus.loading:
        return const Padding(
          padding: AppPadding.v6,
          child: LinearProgressIndicator(minHeight: 2),
        );
      case HeadsUpPacksStatus.error:
        return Text(
          'Could not load word packs.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        );
      case HeadsUpPacksStatus.ready:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: Spacing.md,
              runSpacing: Spacing.md,
              children: [
                for (final pack in state.availablePacks)
                  FilterChip(
                    label: Text(pack.name),
                    selected: state.selectedPackIds.contains(pack.id),
                    onSelected: (_) =>
                        bloc.add(HeadsUpSetupPackToggled(pack.id)),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Text(
              state.words.isEmpty
                  ? 'Pick at least one pack.'
                  : '${state.words.length} words in the deck',
              style: theme.textTheme.bodySmall?.copyWith(
                color: state.words.isEmpty
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
    }
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
  final HeadsUpPlayer player;
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
