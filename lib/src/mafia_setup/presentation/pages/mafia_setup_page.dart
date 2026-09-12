import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_setup/domain/repositories/mafia_host_preferences_repository.dart';
import 'package:house_party_offline/src/mafia_setup/presentation/bloc/mafia_setup_bloc.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';

/// Setup for a Mafia match: roster and options, then start.
class MafiaSetupPage extends StatelessWidget {
  const MafiaSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MafiaSetupBloc(
        getIt<RosterRepository>(),
        getIt<MafiaHostPreferencesRepository>(),
      )..add(const MafiaSetupStarted()),
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
      appBar: AppBar(title: const Text('New Mafia game')),
      body: BlocBuilder<MafiaSetupBloc, MafiaSetupState>(
        builder: (context, state) {
          final bloc = context.read<MafiaSetupBloc>();
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
                          isHost: state.players[i].id == state.hostId,
                          canRemove: state.players.length > state.rosterMinimum,
                          onChanged: (name) => bloc.add(
                            MafiaSetupPlayerRenamed(
                              id: state.players[i].id,
                              name: name,
                            ),
                          ),
                          onRemove: () => bloc.add(
                            MafiaSetupPlayerRemoved(state.players[i].id),
                          ),
                        ),
                      const SizedBox(height: Spacing.md),
                      if (state.players.length < state.rosterCapacity)
                        OutlinedButton.icon(
                          onPressed: () =>
                              bloc.add(const MafiaSetupPlayerAdded()),
                          icon: const Icon(Icons.person_add_alt),
                          label: const Text('Add player'),
                        ),
                      if (!state.hasEnoughPlayers)
                        Padding(
                          padding: const EdgeInsets.only(top: Spacing.lg),
                          child: Text(
                            state.isHosted
                                ? 'Mafia needs '
                                      '${MafiaConfig.minPlayers} players '
                                      'plus the host.'
                                : 'Mafia needs at least '
                                      '${MafiaConfig.minPlayers} players.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      const Divider(),
                      Text('Options', style: theme.textTheme.titleLarge),
                      const SizedBox(height: Spacing.md),
                      _OptionSwitch(
                        title: 'Host runs the night',
                        subtitle: state.isHosted
                            ? 'One person narrates and keeps the phone — '
                                  'no passing after the roles are dealt'
                            : 'Pass the phone to every player each night',
                        value: state.isHosted,
                        onChanged: (value) => bloc.add(
                          MafiaSetupHostModeChanged(enabled: value),
                        ),
                      ),
                      if (state.isHosted) ...[
                        _HostPicker(
                          players: state.players,
                          hostId: state.hostId,
                          onChanged: (id) =>
                              bloc.add(MafiaSetupHostChanged(id)),
                        ),
                        _OptionSwitch(
                          title: 'Rotate the host',
                          subtitle: state.rotateHost
                              ? 'Next game hands narrating to the next '
                                    'person on the list'
                              : 'The same person hosts every game',
                          value: state.rotateHost,
                          onChanged: (value) => bloc.add(
                            MafiaSetupRotateHostChanged(enabled: value),
                          ),
                        ),
                      ],
                      _CountRow(
                        label: 'Mafia',
                        value: state.config.mafiaCount,
                        min: 1,
                        max: state.maxMafia,
                        onChanged: (count) =>
                            bloc.add(MafiaSetupMafiaCountChanged(count)),
                      ),
                      _OptionSwitch(
                        title: 'Include a doctor',
                        subtitle: state.config.includeDoctor
                            ? 'One player can save someone each night'
                            : 'No saves — every mafia kill lands',
                        value: state.config.includeDoctor,
                        onChanged: (value) => bloc.add(
                          MafiaSetupIncludeDoctorChanged(enabled: value),
                        ),
                      ),
                      _OptionSwitch(
                        title: 'Include a detective',
                        subtitle: state.config.includeDetective
                            ? 'One player can investigate someone each night'
                            : 'The town gets no investigations',
                        value: state.config.includeDetective,
                        onChanged: (value) => bloc.add(
                          MafiaSetupIncludeDetectiveChanged(enabled: value),
                        ),
                      ),
                      _OptionSwitch(
                        title: 'Reveal role on death',
                        subtitle: state.config.revealRolesOnDeath
                            ? 'Announce the role of anyone killed or lynched'
                            : 'Only announce who died, not their role',
                        value: state.config.revealRolesOnDeath,
                        onChanged: (value) => bloc.add(
                          MafiaSetupRevealRolesOnDeathChanged(enabled: value),
                        ),
                      ),
                      _OptionSwitch(
                        title: 'First night has a kill',
                        subtitle: state.config.firstNightKill
                            ? 'Mafia may kill on night one'
                            : 'Night one is peaceful',
                        value: state.config.firstNightKill,
                        onChanged: (value) => bloc.add(
                          MafiaSetupFirstNightKillChanged(enabled: value),
                        ),
                      ),
                      // The two rules below only bite when their role is in
                      // the deal.
                      if (state.config.includeDoctor)
                        _OptionSwitch(
                          title: 'Doctor can self-save',
                          subtitle: state.config.doctorSelfSave
                              ? 'The doctor may protect themselves'
                              : 'The doctor cannot protect themselves',
                          value: state.config.doctorSelfSave,
                          onChanged: (value) => bloc.add(
                            MafiaSetupDoctorSelfSaveChanged(enabled: value),
                          ),
                        ),
                      if (state.config.includeDetective)
                        _OptionSwitch(
                          title: 'Detective learns exact role',
                          subtitle: state.config.detectiveExactRole
                              ? 'Investigations reveal the exact role'
                              : "Investigations reveal only 'Mafia' or "
                                    "'Not Mafia'",
                          value: state.config.detectiveExactRole,
                          onChanged: (value) => bloc.add(
                            MafiaSetupDetectiveExactRoleChanged(enabled: value),
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
                        ? () {
                            bloc.add(const MafiaSetupRosterSaved());
                            context.push(
                              AppRoutes.mafiaGame,
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

/// Picks which roster entry narrates. Shown only while host mode is on.
class _HostPicker extends StatelessWidget {
  const _HostPicker({
    required this.players,
    required this.hostId,
    required this.onChanged,
  });

  final List<MafiaPlayer> players;
  final String? hostId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who is hosting?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Wrap(
            spacing: Spacing.md,
            runSpacing: Spacing.md,
            children: [
              for (final p in players)
                ChoiceChip(
                  label: Text(p.name.trim().isEmpty ? 'Unnamed' : p.name),
                  selected: p.id == hostId,
                  onSelected: (_) => onChanged(p.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatefulWidget {
  const _PlayerRow({
    required this.number,
    required this.player,
    required this.isHost,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final int number;
  final MafiaPlayer player;

  /// The narrator, who is dealt no role.
  final bool isHost;
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
            child: widget.isHost
                ? const Icon(Icons.campaign_rounded, size: 20)
                : Text(
                    '${widget.number}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
                helperText: widget.isHost ? 'Host — no role' : null,
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
