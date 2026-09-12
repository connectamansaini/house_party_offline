import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/core/widgets/selectable_player_tile.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_night_card.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_role_visuals.dart';

/// Pass-and-play night. Each living player takes the phone; acting roles pick
/// a target, villagers just pass — so nobody can tell who acted.
class MafiaNightView extends StatelessWidget {
  const MafiaNightView({required this.state, super.key});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    if (!state.isRevealed) return _Cover(state: state);
    if (state.investigationReveal != null) {
      return _Investigation(text: state.investigationReveal!);
    }
    if (state.currentRole == MafiaRole.villager) return _Asleep(state: state);
    return _TargetPicker(state: state);
  }
}

/// Between players: whose turn it is, with the screen still hidden.
class _Cover extends StatelessWidget {
  const _Cover({required this.state});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final player = state.currentPlayer;
    final total = state.session.livingPlayers.length;

    return _Frame(
      body: Column(
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
                    horizontal: Spacing.x8l,
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
                      const SizedBox(height: Spacing.x7l),
                      Text(
                        'The town sleeps.',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        player.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                      const SizedBox(height: Spacing.x3l),
                      Text(
                        'Only they should look 👀',
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
        ],
      ),
      button: FilledButton.icon(
        onPressed: () =>
            context.read<MafiaGameBloc>().add(const NightActorRevealed()),
        icon: const Icon(Icons.visibility),
        label: Text("I'm ${player.name}"),
      ),
    );
  }
}

/// A villager's turn: nothing to do, and the same shape as everyone else's
/// screen so the room can't read anything from how long it takes.
class _Asleep extends StatelessWidget {
  const _Asleep({required this.state});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    return _Frame(
      body: const Center(
        child: SingleChildScrollView(
          child: MomentCard(
            mood: MomentMood.recap,
            gradient: AppColors.nightGradient,
            icon: MomentIcon.moon,
            eyebrow: 'YOUR TURN',
            headline: 'You sleep soundly',
            subtitle:
                'No night powers tonight — hide the screen and pass '
                'it on like everyone else.',
          ),
        ),
      ),
      button: FilledButton.icon(
        onPressed: () =>
            context.read<MafiaGameBloc>().add(const NightActionConfirmed()),
        icon: const Icon(Icons.visibility_off),
        label: const Text('Hide & pass'),
      ),
    );
  }
}

/// What the detective just learned, for their eyes only.
class _Investigation extends StatelessWidget {
  const _Investigation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _Frame(
      body: Center(
        child: SingleChildScrollView(
          child: MomentCard(
            mood: MomentMood.reveal,
            gradient: AppColors.civilianGradient,
            icon: MomentIcon.magnifier,
            eyebrow: 'INVESTIGATION',
            kicker: 'You learn',
            headline: text,
            hint: 'Keep it to yourself until morning.',
          ),
        ),
      ),
      button: FilledButton.icon(
        onPressed: () =>
            context.read<MafiaGameBloc>().add(const NightInvestigationSeen()),
        icon: const Icon(Icons.visibility_off),
        label: const Text('Got it — hide & pass'),
      ),
    );
  }
}

/// An acting role's turn: their instruction, then who they may pick.
class _TargetPicker extends StatelessWidget {
  const _TargetPicker({required this.state});

  final MafiaNight state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MafiaGameBloc>();
    final role = state.currentRole;
    final selected = state.selectedId;
    final selectedName = selected == null
        ? null
        : state.session.playerOf(selected).name;

    final (headline, subtitle) = switch (role) {
      MafiaRole.mafia => (
        'Choose tonight’s victim.',
        'Pick a townsperson to eliminate.',
      ),
      MafiaRole.doctor => (
        'Choose who to protect.',
        'They survive the mafia tonight.',
      ),
      MafiaRole.detective => (
        'Investigate someone.',
        'Learn whose side they are on.',
      ),
      MafiaRole.villager => ('', ''),
    };

    return _Frame(
      header: MafiaNightCard(
        role: role,
        eyebrow: role.label.toUpperCase(),
        headline: headline,
        subtitle: subtitle,
        chip: role.isMafia ? _teammateChip(state) : null,
      ),
      body: ListView(
        // Matches the card's inset so the column has one edge.
        padding: const EdgeInsets.fromLTRB(
          Spacing.x5l,
          Spacing.x3l,
          Spacing.x5l,
          Spacing.x5l,
        ),
        children: [
          for (final p in _candidates(state))
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: SelectablePlayerTile(
                name: p.name,
                selected: p.id == selected,
                accentGradient: roleVisual(role).gradient,
                onTap: () => bloc.add(NightTargetSelected(p.id)),
              ),
            ),
        ],
      ),
      button: FilledButton.icon(
        onPressed: selected == null
            ? null
            : () => bloc.add(const NightActionConfirmed()),
        icon: Icon(_confirmIcon(role)),
        label: Text(
          selectedName == null
              ? 'Choose someone'
              : '${role.nightVerb} $selectedName',
        ),
      ),
    );
  }

  static IconData _confirmIcon(MafiaRole role) => switch (role) {
    MafiaRole.mafia => Icons.mode_night_rounded,
    MafiaRole.doctor => Icons.health_and_safety_rounded,
    MafiaRole.detective => Icons.search_rounded,
    MafiaRole.villager => Icons.check_rounded,
  };

  /// Who else is in on it — or a nudge that there is nobody to hide behind.
  static String _teammateChip(MafiaNight state) {
    final mates = state.session.mafiaTeammateNames(state.currentPlayer.id);
    if (mates.isEmpty) return 'No partners — this one is on you.';
    return 'With: ${mates.join(', ')}';
  }

  /// Who this role may pick tonight.
  static List<MafiaPlayer> _candidates(MafiaNight state) {
    final session = state.session;
    return switch (state.currentRole) {
      // The mafia can't eat their own.
      MafiaRole.mafia => [
        for (final p in session.livingPlayers)
          if (!session.roleOf(p.id).isMafia) p,
      ],
      MafiaRole.doctor => [
        for (final p in session.livingPlayers)
          if (session.config.doctorSelfSave || p.id != state.currentPlayer.id)
            p,
      ],
      // Checking yourself would tell you nothing.
      MafiaRole.detective => [
        for (final p in session.livingPlayers)
          if (p.id != state.currentPlayer.id) p,
      ],
      MafiaRole.villager => session.livingPlayers,
    };
  }
}

/// Shared spacing for a night screen: an optional header, a body that takes
/// the slack, and a full-width action pinned above the system inset.
class _Frame extends StatelessWidget {
  const _Frame({required this.body, required this.button, this.header});

  final Widget? header;
  final Widget body;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.x5l,
              Spacing.x3l,
              Spacing.x5l,
              0,
            ),
            child: header,
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              header == null ? Spacing.x5l : 0,
              header == null ? Spacing.x3l : 0,
              header == null ? Spacing.x5l : 0,
              0,
            ),
            child: body,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            Spacing.x5l,
            Spacing.md,
            Spacing.x5l,
            Spacing.x3l + MediaQuery.of(context).padding.bottom,
          ),
          child: SizedBox(width: double.infinity, child: button),
        ),
      ],
    );
  }
}
