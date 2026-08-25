import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';

/// Final screen: the winning faction and every player's role revealed.
class MafiaGameOverView extends StatelessWidget {
  const MafiaGameOverView({required this.state, super.key});

  final MafiaGameOver state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = state.session;
    final townWon = state.winner == MafiaFaction.town;
    final gradient = townWon
        ? AppColors.civilianGradient
        : AppColors.mafiaGradient;

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                townWon ? Icons.emoji_events_rounded : Icons.dangerous_rounded,
                size: 56,
                color: AppColors.onGradient,
              ),
              const SizedBox(height: 12),
              Text(
                townWon ? 'Town wins! 🎉' : 'Mafia win 🔪',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.onGradient,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Everyone’s role', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final p in session.players)
                _RoleRow(
                  name: p.name,
                  role: session.roleOf(p.id),
                  alive: session.isAlive(p.id),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            8 + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.mafia),
                  child: const Text('Play again'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.home),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Games'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoleRow extends StatelessWidget {
  const _RoleRow({required this.name, required this.role, required this.alive});

  final String name;
  final MafiaRole role;
  final bool alive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: role.isMafia
              ? scheme.errorContainer
              : scheme.primaryContainer,
          foregroundColor: role.isMafia
              ? scheme.onErrorContainer
              : scheme.onPrimaryContainer,
          child: Icon(
            role.isMafia ? Icons.dangerous_rounded : Icons.person_rounded,
            size: 20,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            decoration: alive ? null : TextDecoration.lineThrough,
            color: alive ? null : scheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(role.label),
        trailing: Text(
          alive ? 'Alive' : 'Dead',
          style: theme.textTheme.labelLarge?.copyWith(
            color: alive ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
