import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/app_motion.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/heads_up/presentation/bloc/heads_up_game_bloc.dart';

/// The countdown, then the live turn: a huge word for the room to see, the
/// clock, and the two buttons that mirror the tilt gestures.
class PlayView extends StatelessWidget {
  const PlayView({required this.state, super.key});

  final HeadsUpGameState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bloc = context.read<HeadsUpGameBloc>();
    final counting = state.phase == HeadsUpPhase.countdown;
    final accent = AppColors.accentOf(AppColors.signalGradient);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, 0),
          child: Row(
            children: [
              Text(
                state.session.currentPlayer.name,
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              Icon(
                Icons.check_rounded,
                size: 18,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: Spacing.xs),
              Text('${state.turnScore}', style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: AppMotion.fast,
              transitionBuilder: AppMotion.fadeRise,
              child: counting
                  ? Text(
                      key: ValueKey('count-${state.secondsLeft}'),
                      '${state.secondsLeft}',
                      style: const TextStyle(fontFamily: 'Unbounded').copyWith(
                        fontSize: 96,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    )
                  : Padding(
                      key: ValueKey('word-${state.session.deckIndex}'),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        state.currentWord ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Unbounded')
                            .copyWith(
                              fontSize: 44,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: scheme.onSurface,
                            ),
                      ),
                    ),
            ),
          ),
        ),
        if (!counting) ...[
          Text(
            '${state.secondsLeft}s',
            style: const TextStyle(fontFamily: 'Unbounded').copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: state.secondsLeft <= 5 ? accent : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(
              value: state.secondsLeft / _roundSeconds(context),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
              color: accent,
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ),
        ],
        Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            Spacing.x5l,
            20,
            Spacing.md + MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: counting
                      ? null
                      : () => bloc.add(const HeadsUpWordJudged(correct: false)),
                  icon: const Icon(Icons.arrow_upward_rounded),
                  label: const Text('Pass'),
                ),
              ),
              const SizedBox(width: Spacing.xl),
              Expanded(
                child: FilledButton.icon(
                  onPressed: counting
                      ? null
                      : () => bloc.add(const HeadsUpWordJudged(correct: true)),
                  icon: const Icon(Icons.arrow_downward_rounded),
                  label: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// The clock's full length, read back from the bloc's setup so the bar
  /// scales correctly for 30, 60 or 90 second turns.
  int _roundSeconds(BuildContext context) =>
      context.read<HeadsUpGameBloc>().roundSeconds;
}
