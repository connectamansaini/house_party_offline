import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: MomentCard(
            mood: MomentMood.celebration,
            gradient: gradient,
            icon: townWon ? MomentIcon.laurel : MomentIcon.dagger,
            headline: townWon ? 'Town wins!' : 'Mafia wins!',
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
