import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../domain/entities/player.dart';
import '../game_state.dart';

/// Final standings once the host ends the game.
class GameOverView extends StatelessWidget {
  const GameOverView({super.key, required this.state});

  final GameOver state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final standings = state.session.standings;
    final topScore = standings.isEmpty ? 0 : standings.first.cumulativeScore;
    final winners = standings.where(
      (p) => p.cumulativeScore == topScore && topScore > 0,
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            gradient: AppColors.winGradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.winGradient.colors.first.withValues(
                  alpha: 0.4,
                ),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 56,
                color: AppColors.onGradient,
              ),
              const SizedBox(height: 12),
              Text(
                topScore == 0 ? 'Game over' : _winnerLine(winners),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.onGradient,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: standings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = standings[i];
              final isWinner = p.cumulativeScore == topScore && topScore > 0;
              return _StandingTile(rank: i + 1, player: p, isWinner: isWinner);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            8 + MediaQuery.of(context).padding.bottom,
          ),
          child: FilledButton.icon(
            onPressed: () => context.go(AppRoutes.home),
            icon: const Icon(Icons.home_rounded),
            label: const Text('Back to games'),
          ),
        ),
      ],
    );
  }

  String _winnerLine(Iterable<Player> winners) {
    final names = winners.map((p) => p.name).toList();
    if (names.length == 1) return '${names.first} wins! 🏆';
    return "It's a tie! 🏆";
  }
}

class _StandingTile extends StatelessWidget {
  const _StandingTile({
    required this.rank,
    required this.player,
    required this.isWinner,
  });

  final int rank;
  final Player player;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const medals = {1: '🥇', 2: '🥈', 3: '🥉'};

    return Card(
      color: isWinner ? scheme.tertiaryContainer : scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                medals[rank] ?? '$rank',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                player.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isWinner
                      ? scheme.onTertiaryContainer
                      : scheme.onSurface,
                ),
              ),
            ),
            Text(
              '${player.cumulativeScore}',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isWinner ? scheme.onTertiaryContainer : scheme.primary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
