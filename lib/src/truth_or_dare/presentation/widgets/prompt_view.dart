import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/prompt_card.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/bloc/truth_or_dare_game_bloc.dart';

/// Second beat of a turn: the drawn prompt, and whether they did it.
class PromptView extends StatelessWidget {
  const PromptView({required this.state, super.key});

  final TruthOrDareGameState state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final bloc = context.read<TruthOrDareGameBloc>();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, 0),
          child: PromptCard(
            eyebrow: '${state.kind!.label} for ${session.currentPlayer.name}',
            text: state.prompt!,
            accent: AppColors.accentOf(AppColors.dareGradient),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Score so far: ${session.scores[session.currentPlayer.id] ?? 0}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            Spacing.x3l,
            20,
            Spacing.md + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              FilledButton.icon(
                onPressed: () =>
                    bloc.add(const TruthOrDareTurnResolved(done: true)),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Done — take the point'),
              ),
              const SizedBox(height: Spacing.md),
              TextButton(
                onPressed: () =>
                    bloc.add(const TruthOrDareTurnResolved(done: false)),
                child: const Text('Skip'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
