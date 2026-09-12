import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_role_visuals.dart';

/// Pass-and-play initial reveal: each player privately sees their role.
class MafiaRoleRevealView extends StatelessWidget {
  const MafiaRoleRevealView({required this.state, super.key});

  final MafiaRoleReveal state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = state.currentPlayer;
    final total = state.session.players.length;
    // With a narrator the phone is handed round by them, so the prompts
    // address the host rather than the player.
    final hosted = state.session.isHosted;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Text(
            'Player ${state.currentIndex + 1} of $total',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: state.isRevealed
                    ? _RoleCard(
                        key: const ValueKey('role'),
                        state: state,
                      )
                    : _Cover(
                        key: const ValueKey('cover'),
                        name: player.name,
                        hosted: hosted,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (state.isRevealed)
            FilledButton.icon(
              onPressed: () =>
                  context.read<MafiaGameBloc>().add(const RolePassed()),
              icon: Icon(
                state.isLastPlayer
                    ? Icons.nightlight_round
                    : Icons.visibility_off,
              ),
              label: Text(
                state.isLastPlayer
                    ? 'Begin night 1'
                    : (hosted ? 'Hide & move on' : 'Hide & pass'),
              ),
            )
          else
            FilledButton.icon(
              onPressed: () =>
                  context.read<MafiaGameBloc>().add(const RoleRevealed()),
              icon: const Icon(Icons.visibility),
              label: Text(
                hosted
                    ? 'Show ${player.name} their role'
                    : "I'm ${player.name} — reveal role",
              ),
            ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.name, required this.hosted, super.key});

  final String name;
  final bool hosted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pan_tool_alt_outlined, size: 64, color: scheme.primary),
            const SizedBox(height: 24),
            Text(
              hosted ? 'Take the phone to' : 'Pass the phone to',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Only they should look 👀',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.state, super.key});

  final MafiaRoleReveal state;

  @override
  Widget build(BuildContext context) {
    final role = state.session.roleOf(state.currentPlayer.id);
    final visual = roleVisual(role);

    return MomentCard(
      mood: MomentMood.reveal,
      gradient: visual.gradient,
      icon: visual.icon,
      kicker: 'You are',
      headline: role.label,
      subtitle: visual.tagline,
      hint: role.isMafia
          ? _mafiaHint(
              state.session.mafiaTeammateNames(state.currentPlayer.id),
            )
          : null,
    );
  }

  /// Who else is in on it — the one line a new mafia actually needs, and a
  /// warning when there is nobody to share the blame with.
  static String _mafiaHint(List<String> teammates) =>
      switch (teammates.length) {
        0 => 'You are the only mafia — no partners, no cover.',
        1 => 'Your partner in crime: ${teammates.first}.',
        _ => 'Your mafia: ${teammates.join(', ')}.',
      };
}
