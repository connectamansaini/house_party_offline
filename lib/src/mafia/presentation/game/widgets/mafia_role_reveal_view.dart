import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/mafia/presentation/game/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia/presentation/game/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia/presentation/game/mafia_game_state.dart';
import 'package:house_party_offline/src/mafia/presentation/game/widgets/mafia_role_visuals.dart';

/// Pass-and-play initial reveal: each player privately sees their role.
class MafiaRoleRevealView extends StatelessWidget {
  const MafiaRoleRevealView({required this.state, super.key});

  final MafiaRoleReveal state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = state.currentPlayer;
    final total = state.session.players.length;

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
                    : _Cover(key: const ValueKey('cover'), name: player.name),
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
                state.isLastPlayer ? 'Begin night 1' : 'Hide & pass',
              ),
            )
          else
            FilledButton.icon(
              onPressed: () =>
                  context.read<MafiaGameBloc>().add(const RoleRevealed()),
              icon: const Icon(Icons.visibility),
              label: Text("I'm ${player.name} — reveal role"),
            ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.name, super.key});

  final String name;

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
            Text('Pass the phone to', style: theme.textTheme.titleMedium),
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
    final theme = Theme.of(context);
    final role = state.session.roleOf(state.currentPlayer.id);
    final visual = roleVisual(role);
    final teammates = role.isMafia
        ? state.session.mafiaTeammateNames(state.currentPlayer.id)
        : const <String>[];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: visual.gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: visual.gradient.colors.first.withValues(alpha: 0.4),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(visual.icon, size: 60, color: AppColors.onGradient),
            const SizedBox(height: 16),
            Text(
              'You are',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.onGradient.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              role.label,
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.onGradient,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              visual.tagline,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.onGradient.withValues(alpha: 0.9),
              ),
            ),
            if (teammates.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Your mafia: ${teammates.join(', ')}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.onGradient,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
