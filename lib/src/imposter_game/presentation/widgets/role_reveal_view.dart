import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/role.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_bloc.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_event.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_state.dart';

/// Pass-and-play role reveal: a privacy cover for the current player, then
/// their secret role, then a pass to the next player.
class RoleRevealView extends StatelessWidget {
  const RoleRevealView({required this.state, super.key});

  final RoleReveal state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = state.currentPlayer;
    final total = state.session.players.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          _ProgressDots(count: total, current: state.currentIndex),
          const SizedBox(height: 8),
          Text(
            'Player ${state.currentIndex + 1} of $total',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.96, end: 1).animate(anim),
                    child: child,
                  ),
                ),
                child: state.isRevealed
                    ? _RoleCard(
                        key: const ValueKey('role'),
                        role: state.assignment.roleOf(player.id),
                      )
                    : _PassCover(
                        key: const ValueKey('cover'),
                        name: player.name,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (state.isRevealed)
            FilledButton.icon(
              onPressed: () => context.read<GameBloc>().add(const RolePassed()),
              icon: Icon(
                state.isLastPlayer ? Icons.forum_rounded : Icons.visibility_off,
              ),
              label: Text(
                state.isLastPlayer ? 'Start discussion' : 'Hide & pass',
              ),
            )
          else
            FilledButton.icon(
              onPressed: () =>
                  context.read<GameBloc>().add(const RoleRevealed()),
              icon: const Icon(Icons.visibility),
              label: Text("I'm ${player.name} — reveal"),
            ),
        ],
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == current ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i <= current
                  ? scheme.primary
                  : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

class _PassCover extends StatelessWidget {
  const _PassCover({required this.name, super.key});

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
              style: theme.textTheme.displaySmall?.copyWith(
                color: scheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Make sure nobody else is looking 👀',
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
  const _RoleCard({required this.role, super.key});

  final Role role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (gradient, icon, title, subtitle) = switch (role) {
      CivilianRole(:final secretWord) => (
        AppColors.civilianGradient,
        Icons.vpn_key_rounded,
        secretWord,
        'Your secret word',
      ),
      // Undercover: show the decoy word as the headline;
      // blank: show "IMPOSTER".
      ImposterRole(:final decoyWord) when decoyWord != null => (
        AppColors.imposterGradient,
        Icons.theater_comedy_rounded,
        decoyWord,
        'IMPOSTER — blend in with',
      ),
      ImposterRole() => (
        AppColors.imposterGradient,
        Icons.theater_comedy_rounded,
        'IMPOSTER',
        "You don't know the word. Blend in.",
      ),
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.4),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 44),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: AppColors.onGradient),
            const SizedBox(height: 20),
            Text(
              subtitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.onGradient.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.onGradient,
              ),
              textAlign: TextAlign.center,
            ),
            if (role.categoryHint != null) ...[
              const SizedBox(height: 22),
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
                  'Hint: ${role.categoryHint}',
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
