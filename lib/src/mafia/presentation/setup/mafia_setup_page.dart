import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia/presentation/setup/mafia_setup_cubit.dart';

/// Setup for a Mafia match: roster and options, then start.
class MafiaSetupPage extends StatelessWidget {
  const MafiaSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MafiaSetupCubit(),
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
      appBar: AppBar(title: const Text('New Mafia game')),
      body: BlocBuilder<MafiaSetupCubit, MafiaSetupState>(
        builder: (context, state) {
          final cubit = context.read<MafiaSetupCubit>();
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    Text('Players', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    for (var i = 0; i < state.players.length; i++)
                      _PlayerRow(
                        key: ValueKey(state.players[i].id),
                        number: i + 1,
                        player: state.players[i],
                        canRemove:
                            state.players.length > MafiaConfig.minPlayers,
                        onChanged: (name) =>
                            cubit.renamePlayer(state.players[i].id, name),
                        onRemove: () => cubit.removePlayer(state.players[i].id),
                      ),
                    const SizedBox(height: 8),
                    if (state.players.length < MafiaConfig.maxPlayers)
                      OutlinedButton.icon(
                        onPressed: cubit.addPlayer,
                        icon: const Icon(Icons.person_add_alt),
                        label: const Text('Add player'),
                      ),
                    if (!state.hasEnoughPlayers)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Mafia needs at least ${MafiaConfig.minPlayers} players.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    const Divider(),
                    Text('Options', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    _CountRow(
                      label: 'Mafia',
                      value: state.config.mafiaCount,
                      min: 1,
                      max: state.maxMafia,
                      onChanged: cubit.setMafiaCount,
                    ),
                    _OptionSwitch(
                      title: 'Reveal role on death',
                      subtitle: state.config.revealRolesOnDeath
                          ? 'Announce the role of anyone killed or lynched'
                          : 'Only announce who died, not their role',
                      value: state.config.revealRolesOnDeath,
                      onChanged: (value) => cubit.setRevealRolesOnDeath(value: value),
                    ),
                    _OptionSwitch(
                      title: 'First night has a kill',
                      subtitle: state.config.firstNightKill
                          ? 'Mafia may kill on night one'
                          : 'Night one is peaceful',
                      value: state.config.firstNightKill,
                      onChanged: (value) => cubit.setFirstNightKill(value: value),
                    ),
                    _OptionSwitch(
                      title: 'Doctor can self-save',
                      subtitle: state.config.doctorSelfSave
                          ? 'The doctor may protect themselves'
                          : 'The doctor cannot protect themselves',
                      value: state.config.doctorSelfSave,
                      onChanged: (value) => cubit.setDoctorSelfSave(value: value),
                    ),
                    _OptionSwitch(
                      title: 'Detective learns exact role',
                      subtitle: state.config.detectiveExactRole
                          ? 'Investigations reveal the exact role'
                          : "Investigations reveal only 'Mafia' or 'Not Mafia'",
                      value: state.config.detectiveExactRole,
                      onChanged: (value) => cubit.setDetectiveExactRole(value: value),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  8 + MediaQuery.of(context).padding.bottom,
                ),
                child: FilledButton.icon(
                  onPressed: state.canStart
                      ? () => context.push(
                          AppRoutes.mafiaGame,
                          extra: state.buildSetup(),
                        )
                      : null,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start game'),
                ),
              ),
            ],
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
  final MafiaPlayer player;
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.onPrimaryContainer,
            child: Text(
              '${widget.number}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              style: Theme.of(context).textTheme.titleMedium,
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
      padding: const EdgeInsets.symmetric(vertical: 4),
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

class _OptionSwitch extends StatelessWidget {
  const _OptionSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
