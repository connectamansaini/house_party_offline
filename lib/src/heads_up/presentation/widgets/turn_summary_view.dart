import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/heads_up/presentation/bloc/heads_up_game_bloc.dart';

/// Time's up: what the player scored and every word they faced.
class TurnSummaryView extends StatelessWidget {
  const TurnSummaryView({required this.state, super.key});

  final HeadsUpGameState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final session = state.session;
    // endTurn has already advanced the turn, so the player who just went is
    // the one before the current one.
    final player =
        session.players[(session.turnsPlayed - 1) % session.players.length];
    final score = state.turnScore;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: MomentCard(
            mood: MomentMood.recap,
            gradient: AppColors.signalGradient,
            icon: MomentIcon.laurel,
            eyebrow: "Time's up",
            headline: '${player.name} got $score',
            subtitle: score == 1
                ? '1 word this turn.'
                : '$score words this turn.',
          ),
        ),
        const SizedBox(height: Spacing.xl),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              for (final guess in state.turnGuesses)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    guess.correct ? Icons.check_rounded : Icons.close_rounded,
                    color: guess.correct
                        ? AppColors.legible(
                            AppColors.accentOf(AppColors.dareGradient),
                            theme.brightness,
                          )
                        : scheme.onSurfaceVariant,
                  ),
                  title: Text(guess.word),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            Spacing.md + MediaQuery.of(context).padding.bottom,
          ),
          child: FilledButton(
            onPressed: () => context.read<HeadsUpGameBloc>().add(
              const HeadsUpTurnFinished(),
            ),
            child: Text(
              session.isOver
                  ? 'See results'
                  : 'Next: ${session.currentPlayer.name}',
            ),
          ),
        ),
      ],
    );
  }
}
