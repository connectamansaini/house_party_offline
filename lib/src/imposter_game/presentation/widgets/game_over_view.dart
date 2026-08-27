import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter_game/presentation/bloc/game_state.dart';

/// Final standings once the host ends the game.
class GameOverView extends StatelessWidget {
  const GameOverView({required this.state, super.key});

  final GameOver state;

  @override
  Widget build(BuildContext context) {
    final standings = state.session.standings;
    final topScore = standings.isEmpty ? 0 : standings.first.cumulativeScore;
    final winners = standings.where(
      (p) => p.cumulativeScore == topScore && topScore > 0,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: MomentCard(
            mood: MomentMood.celebration,
            gradient: AppColors.winGradient,
            icon: MomentIcon.laurel,
            headline: topScore == 0 ? 'Game over' : _winnerLine(winners),
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
    if (names.length == 1) return '${names.first} wins!';
    return "It's a tie!";
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
