import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
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
              decoration: InputDecoration(
                hintText: 'Player ${widget.number}',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
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
        children: [
          for (final pack in state.availablePacks)
            _PackOption(
              pack: pack,
              selected: pack.id == state.selectedPack?.id,
              onTap: () => cubit.selectPack(pack.id),
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
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      selected: selected,
      onTap: onTap,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? scheme.primary : scheme.onSurfaceVariant,
      ),
      title: Text(pack.name),
      subtitle: Text('${pack.category} • ${pack.words.length} words'),
      trailing: pack.isCustom
          ? const Chip(
              label: Text('Custom'),
              visualDensity: VisualDensity.compact,
            )
          : null,
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
          label: 'Imposters',
          value: state.imposterCount,
          min: 1,
          max: state.maxImposters,
          onChanged: cubit.setImposterCount,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Give imposter a category hint'),
          subtitle: Text(
            state.categoryHintEnabled
                ? 'Imposter sees "${state.selectedPack?.category ?? ''}"'
                : 'Imposter sees nothing',
          ),
          value: state.categoryHintEnabled,
          onChanged: cubit.setCategoryHint,
        ),
        _Stepper(
          label: 'Discussion (min)',
          value: state.discussionMinutes,
          min: 1,
          max: 15,
          onChanged: cubit.setDiscussionMinutes,
        ),
        _Stepper(
          label: 'Crew win points',
          value: state.crewWinPoints,
          min: 1,
          max: 10,
          onChanged: cubit.setCrewWinPoints,
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
