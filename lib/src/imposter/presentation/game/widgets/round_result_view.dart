import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../domain/entities/round_result.dart';
import '../game_bloc.dart';
import '../game_event.dart';
import '../game_state.dart';

/// Shows the resolved round: who won, the reveal, and updated scores.
class RoundResultView extends StatelessWidget {
  const RoundResultView({super.key, required this.state});

  final RoundResultState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = state.result;
    final civilianWon = result.winningSide == WinningSide.civilian;
    final gradient =
        civilianWon ? AppColors.civilianGradient : AppColors.imposterGradient;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                width: double.infinity,
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
                      civilianWon ? Icons.groups_rounded : Icons.theater_comedy_rounded,
                      size: 52,
                      color: AppColors.onGradient,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      civilianWon ? 'Civilians win! 🎉' : 'Imposter wins! 🎭',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.onGradient,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (result.imposterGuessedRight) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Stolen with a correct guess!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.onGradient.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _InfoRow(label: 'Voted out', value: state.votedOut.name),
                      _InfoRow(
                        label: 'Imposter',
                        value: state.imposters.map((p) => p.name).join(', '),
                      ),
                      _InfoRow(
                        label: 'Secret word',
                        value: state.assignment.secretWord,
                        emphasize: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Scores', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final p in state.session.standings)
                _ScoreRow(
                  name: p.name,
                  total: p.cumulativeScore,
                  delta: result.scoreDeltas[p.id] ?? 0,
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8 + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.read<GameBloc>().add(const GameEnded()),
                  child: const Text('End game'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      context.read<GameBloc>().add(const NextRoundRequested()),
                  child: const Text('Next round'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: emphasize
                  ? theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    )
                  : theme.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.name,
    required this.total,
    required this.delta,
  });

  final String name;
  final int total;
  final int delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(name, style: theme.textTheme.bodyLarge)),
          if (delta > 0)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$delta',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onTertiaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Text(
            '$total',
            style: theme.textTheme.titleMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
