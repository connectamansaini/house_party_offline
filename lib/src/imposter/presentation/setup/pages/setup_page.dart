import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../domain/entities/imposter_mode.dart';
import '../../../domain/entities/player.dart';
import '../../../domain/entities/word_pack.dart';
import '../../../domain/repositories/imposter_settings_repository.dart';
import '../../../domain/repositories/word_pack_repository.dart';
import '../setup_cubit.dart';
import '../setup_state.dart';

/// Setup flow: enter players, pick a word pack, choose options, then start.
class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SetupCubit(
        sl<WordPackRepository>(),
        sl<ImposterSettingsRepository>(),
      )..init(),
      child: const _SetupView(),
    );
  }
}

class _SetupView extends StatefulWidget {
  const _SetupView();

  @override
  State<_SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<_SetupView> {
  static const _titles = ['Players', 'Word pack', 'Options'];
  int _step = 0;

  bool _canAdvance(SetupState state) => switch (_step) {
    0 => state.hasEnoughPlayers && state.allNamesFilled,
    1 => state.hasUsablePacks,
    _ => state.canStart,
  };

  Future<void> _onContinue(SetupCubit cubit, SetupState state) async {
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    if (!state.canStart) return;
    final setup = state.buildSetup();
    final router = GoRouter.of(context);
    await cubit.persist();
    if (!mounted) return;
    router.push(Routes.imposterGame, extra: setup);
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('New game')),
      body: BlocBuilder<SetupCubit, SetupState>(
        builder: (context, state) {
          final cubit = context.read<SetupCubit>();
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
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _titles[_step],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          switch (_step) {
                            0 => _PlayersStep(state: state, cubit: cubit),
                            1 => _PackStep(state: state, cubit: cubit),
                            _ => _OptionsStep(state: state, cubit: cubit),
                          },
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    8 + MediaQuery.of(context).padding.bottom,
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
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: _canAdvance(state)
                              ? () => _onContinue(cubit, state)
                              : null,
                          icon: Icon(
                            isLast ? Icons.play_arrow_rounded : Icons.arrow_forward,
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      titles[i],
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: i == current
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                        fontWeight:
                            i == current ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (i < titles.length - 1) const SizedBox(width: 8),
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
  const _PlayersStep({required this.state, required this.cubit});

  final SetupState state;
  final SetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canRemove = state.players.length > SetupState.minPlayers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < state.players.length; i++)
          _PlayerRow(
            key: ValueKey(state.players[i].id),
            number: i + 1,
            player: state.players[i],
            canRemove: canRemove,
            onChanged: (name) => cubit.renamePlayer(state.players[i].id, name),
            onRemove: () => cubit.removePlayer(state.players[i].id),
          ),
        const SizedBox(height: 12),
        if (state.players.length < SetupState.maxPlayers)
          OutlinedButton.icon(
            onPressed: cubit.addPlayer,
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Add player'),
          ),
        if (!state.hasEnoughPlayers)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Add at least ${SetupState.minPlayers} players.',
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
    super.key,
    required this.number,
    required this.player,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
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
  late final TextEditingController _controller =
      TextEditingController(text: widget.player.name);

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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              style: theme.textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: 'Player ${widget.number}',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          const SizedBox(width: 4),
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
  const _PackStep({required this.state, required this.cubit});

  final SetupState state;
  final SetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    return switch (state.packsStatus) {
      PacksStatus.loading => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      PacksStatus.error => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(state.errorMessage ?? 'Failed to load packs.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: cubit.loadPacks,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      PacksStatus.ready => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${state.selectedPackIds.length} of ${state.availablePacks.length} packs'
                  ' • ${state.selectedWordCount} words',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: state.allPacksSelected
                    ? cubit.clearPacks
                    : cubit.selectAllPacks,
                child: Text(state.allPacksSelected ? 'Clear' : 'Select all'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (final pack in state.availablePacks)
            _PackOption(
              pack: pack,
              selected: state.selectedPackIds.contains(pack.id),
              onTap: () => cubit.togglePack(pack.id),
            ),
          if (!state.hasUsablePacks)
            Padding(
              padding: const EdgeInsets.only(top: 8),
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

  final WordPack pack;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? scheme.primaryContainer : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
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
  const _OptionsStep({required this.state, required this.cubit});

  final SetupState state;
  final SetupCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Stepper(
          label: 'Imposter',
          value: state.imposterCount,
          min: 1,
          max: state.maxImposters,
          onChanged: cubit.setImposterCount,
        ),
        const SizedBox(height: 12),
        _ImposterModeSelector(state: state, cubit: cubit),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Give the imposter a category hint'),
          subtitle: Text(
            state.categoryHintEnabled
                ? "The imposter sees the word's category"
                : 'The imposter sees nothing',
          ),
          value: state.categoryHintEnabled,
          onChanged: cubit.setCategoryHint,
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
          onChanged: cubit.setSecretVoting,
        ),
        _Stepper(
          label: 'Discussion (min)',
          value: state.discussionMinutes,
          min: 1,
          max: 15,
          onChanged: cubit.setDiscussionMinutes,
        ),
        _Stepper(
          label: 'Civilian win points',
          value: state.civilianWinPoints,
          min: 1,
          max: 10,
          onChanged: cubit.setCivilianWinPoints,
        ),
        _Stepper(
          label: 'Imposter win points',
          value: state.imposterWinPoints,
          min: 1,
          max: 10,
          onChanged: cubit.setImposterWinPoints,
        ),
      ],
    );
  }
}

/// Segmented choice for what the imposter receives at reveal.
class _ImposterModeSelector extends StatelessWidget {
  const _ImposterModeSelector({required this.state, required this.cubit});

  final SetupState state;
  final SetupCubit cubit;

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
        const SizedBox(height: 8),
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
            onSelectionChanged: (s) => cubit.setImposterMode(s.first),
          ),
        ),
        const SizedBox(height: 6),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
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
