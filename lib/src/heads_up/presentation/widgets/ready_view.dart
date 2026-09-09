import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/prompt_card.dart';
import 'package:house_party_offline/src/heads_up/presentation/bloc/heads_up_game_bloc.dart';

/// Between turns: whose turn it is, and the one instruction that matters.
class ReadyView extends StatelessWidget {
  const ReadyView({required this.state, super.key});

  final HeadsUpGameState state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, 0),
          child: PromptCard(
            eyebrow: 'Round ${session.roundNumber} of ${session.roundCount}',
            text: "${session.currentPlayer.name}, you're up!",
            accent: AppColors.accentOf(AppColors.signalGradient),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Hold the phone on your forehead, screen facing the room. '
            'Everyone else gives clues.\n\n'
            'Tilt down when you get it. Tilt up to pass.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            Spacing.md + MediaQuery.of(context).padding.bottom,
          ),
          child: FilledButton.icon(
            onPressed: () =>
                context.read<HeadsUpGameBloc>().add(const HeadsUpTurnStarted()),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start my turn'),
          ),
        ),
      ],
    );
  }
}
