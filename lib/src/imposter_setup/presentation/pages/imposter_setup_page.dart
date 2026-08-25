import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/core/widgets/loader.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/imposter_mode.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/load_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/save_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/presentation/bloc/imposter_setup_bloc.dart';

/// Setup flow: enter players, pick a word pack, choose options, then start.
class ImposterSetupPage extends StatelessWidget {
  const ImposterSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ImposterSetupBloc(
              getIt<LoadImposterSetupPreferencesUseCase>(),
              getIt<SaveImposterSetupPreferencesUseCase>(),
              getIt<GetImposterPacksUseCase>(),
            )
            ..add(const ImposterSetupStarted()),
      child: const _ImposterSetupView(),
    );
  }
}

class _ImposterSetupView extends StatefulWidget {
  const _ImposterSetupView();

  @override
  State<_ImposterSetupView> createState() => _ImposterSetupViewState();
}

class _ImposterSetupViewState extends State<_ImposterSetupView> {
  static const _titles = ['Players', 'Word pack', 'Options'];
  int _step = 0;

  bool _canAdvance(ImposterSetupState state) => switch (_step) {
    0 => state.hasEnoughPlayers && state.allNamesFilled,
    1 => state.hasUsablePacks,
    _ => state.canStart,
  };

  Future<void> _onContinue(
    ImposterSetupBloc bloc,
    ImposterSetupState state,
  ) async {
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    if (!state.canStart) return;
    final setup = state.buildSetup();
    final router = GoRouter.of(context);
    await bloc.persist();
    if (!mounted) return;
    unawaited(router.push(AppRoutes.imposterGame, extra: setup));
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('New game')),
      body: BlocBuilder<ImposterSetupBloc, ImposterSetupState>(
        builder: (context, state) {
          final bloc = context.read<ImposterSetupBloc>();
          final isLast = _step == 2;
          return SafeArea(
            child: Column(
              children: [
                _StepHeader(
                  titles: _titles,
                  current: _step,
                  onTap: (i) => setState(() => _step = i),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: SingleChildScrollView(
                      key: ValueKey(_step),
                      padding: AppPadding.page,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titles[_step],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: Spacing.x3l),
                          switch (_step) {
                            0 => _PlayersStep(state: state, bloc: bloc),
                            1 => _PackStep(state: state, bloc: bloc),
                            _ => _OptionsStep(state: state, bloc: bloc),
                          },
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    Spacing.md,
                    20,
                    Spacing.md + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Row(
                    children: [
                      if (_step > 0) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _step--),
                            child: const Text('Back'),
                          ),
                        ),
                        const SizedBox(width: Spacing.xl),
                      ],
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: _canAdvance(state)
                              ? () => _onContinue(bloc, state)
                              : null,
                          icon: Icon(
                            isLast
                                ? Icons.play_arrow_rounded
                                : Icons.arrow_forward,
                          ),
                          label: Text(isLast ? 'Start game' : 'Next'),
                        ),
                      ),
                    ],
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

/// Segmented progress header for the setup steps.
class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.titles,
    required this.current,
    required this.onTap,
  });

  final List<String> titles;
  final int current;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, Spacing.xl, 20, Spacing.xl),
      child: Row(
        children: [
          for (var i = 0; i < titles.length; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: i <= current ? () => onTap(i) : null,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 6,
                      decoration: BoxDecoration(
                        color: i <= current
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadii.xs),
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      titles[i],
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: i == current
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                        fontWeight: i == current
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (i < titles.length - 1) const SizedBox(width: Spacing.md),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 1 — Players
// ---------------------------------------------------------------------------

class _PlayersStep extends StatelessWidget {
  const _PlayersStep({required this.state, required this.bloc});

  final ImposterSetupState state;
  final ImposterSetupBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canRemove = state.players.length > ImposterSetupState.minPlayers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < state.players.length; i++)
          _PlayerRow(
            key: ValueKey(state.players[i].id),
            number: i + 1,
            player: state.players[i],
            canRemove: canRemove,
            onChanged: (name) => bloc.add(
              ImposterSetupPlayerRenamed(id: state.players[i].id, name: name),
            ),
            onRemove: () =>
                bloc.add(ImposterSetupPlayerRemoved(state.players[i].id)),
          ),
        const SizedBox(height: Spacing.xl),
        if (state.players.length < ImposterSetupState.maxPlayers)
          OutlinedButton.icon(
            onPressed: () => bloc.add(const ImposterSetupPlayerAdded()),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Add player'),
          ),
        if (!state.hasEnoughPlayers)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.lg),
            child: Text(
              'Add at least ${ImposterSetupState.minPlayers} players.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
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
  final Player player;
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: Spacing.xl),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              style: theme.textTheme.titleMedium,
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

// ---------------------------------------------------------------------------
// Step 2 — Word pack
// ---------------------------------------------------------------------------

class _PackStep extends StatelessWidget {
  const _PackStep({required this.state, required this.bloc});

  final ImposterSetupState state;
  final ImposterSetupBloc bloc;

  @override
  Widget build(BuildContext context) {
    return switch (state.packsStatus) {
      ImposterSetupPacksStatus.loading => const Padding(
        padding: AppPadding.all2xl,
        child: Loader(label: 'Loading word packs...'),
      ),
      ImposterSetupPacksStatus.error => Padding(
        padding: AppPadding.allMd,
        child: Column(
          children: [
            Text(state.errorMessage ?? 'Failed to load packs.'),
            const SizedBox(height: Spacing.xl),
            FilledButton(
              onPressed: () =>
                  bloc.add(const ImposterSetupPacksRefreshRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      ImposterSetupPacksStatus.ready => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${state.selectedPackIds.length} of '
                  '${state.availablePacks.length} packs'
                  ' • ${state.selectedWordCount} words',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => bloc.add(
                  state.allPacksSelected
                      ? const ImposterSetupPacksCleared()
                      : const ImposterSetupAllPacksSelected(),
                ),
                child: Text(state.allPacksSelected ? 'Clear' : 'Select all'),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          for (final pack in state.availablePacks)
            _PackOption(
              pack: pack,
              selected: state.selectedPackIds.contains(pack.id),
              onTap: () => bloc.add(ImposterSetupPackToggled(pack.id)),
            ),
          if (!state.hasUsablePacks)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.md),
              child: Text(
                'Select at least one pack.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    };
  }
}

class _PackOption extends StatelessWidget {
  const _PackOption({
    required this.pack,
    required this.selected,
    required this.onTap,
  });

  final ImposterPackEntity pack;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadii.x3l),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: AppPadding.chip,
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: Spacing.xl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pack.name, style: theme.textTheme.titleMedium),
                      Text(
                        '${pack.category} • ${pack.words.length} words',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (pack.isCustom)
                  const Chip(
                    label: Text('Custom'),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 3 — Options
// ---------------------------------------------------------------------------

class _OptionsStep extends StatelessWidget {
  const _OptionsStep({required this.state, required this.bloc});

  final ImposterSetupState state;
  final ImposterSetupBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Stepper(
          label: 'Imposter',
          value: state.imposterCount,
          min: 1,
          max: state.maxImposters,
          onChanged: (count) =>
              bloc.add(ImposterSetupImposterCountChanged(count)),
        ),
        const SizedBox(height: Spacing.xl),
        _ImposterModeSelector(state: state, bloc: bloc),
        const SizedBox(height: Spacing.md),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Give the imposter a category hint'),
          subtitle: Text(
            state.categoryHintEnabled
                ? "The imposter sees the word's category"
                : 'The imposter sees nothing',
          ),
          value: state.categoryHintEnabled,
          onChanged: (value) =>
              bloc.add(ImposterSetupCategoryHintChanged(enabled: value)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Secret voting'),
          subtitle: Text(
            state.secretVoting
                ? 'Each player votes privately (pass & play), then tally'
                : 'The group casts one shared vote',
          ),
          value: state.secretVoting,
          onChanged: (value) =>
              bloc.add(ImposterSetupSecretVotingChanged(enabled: value)),
        ),
        _Stepper(
          label: 'Discussion (min)',
          value: state.discussionMinutes,
          min: 1,
          max: 15,
          onChanged: (minutes) =>
              bloc.add(ImposterSetupDiscussionMinutesChanged(minutes)),
        ),
        _Stepper(
          label: 'Civilian win points',
          value: state.civilianWinPoints,
          min: 1,
          max: 10,
          onChanged: (points) =>
              bloc.add(ImposterSetupCivilianWinPointsChanged(points)),
        ),
        _Stepper(
          label: 'Imposter win points',
          value: state.imposterWinPoints,
          min: 1,
          max: 10,
          onChanged: (points) =>
              bloc.add(ImposterSetupImposterWinPointsChanged(points)),
        ),
      ],
    );
  }
}

/// Segmented choice for what the imposter receives at reveal.
class _ImposterModeSelector extends StatelessWidget {
  const _ImposterModeSelector({required this.state, required this.bloc});

  final ImposterSetupState state;
  final ImposterSetupBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imposter gets',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.md),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ImposterMode>(
            segments: const [
              ButtonSegment(
                value: ImposterMode.blank,
                icon: Icon(Icons.block),
                label: Text('No word'),
              ),
              ButtonSegment(
                value: ImposterMode.undercover,
                icon: Icon(Icons.swap_horiz),
                label: Text('Decoy word'),
              ),
            ],
            selected: {state.imposterMode},
            showSelectedIcon: false,
            onSelectionChanged: (s) =>
                bloc.add(ImposterSetupImposterModeChanged(s.first)),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          state.imposterMode.isUndercover
              ? 'Undercover: the imposter gets a different word from the same '
                    'category to help them blend in.'
              : 'Word Imposter: the imposter gets no word and must bluff.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
