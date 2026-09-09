import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/prompt_card.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_kind.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/bloc/truth_or_dare_game_bloc.dart';

/// First beat of a turn: announce whose turn it is and let them choose.
class ChooseView extends StatelessWidget {
  const ChooseView({required this.state, super.key});

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
            eyebrow: 'Round ${session.roundNumber} of ${session.roundCount}',
            text: '${session.currentPlayer.name}, truth or dare?',
            accent: AppColors.accentOf(AppColors.dareGradient),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Go through with it for a point. Skip and get nothing.',
            textAlign: TextAlign.center,
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => bloc.add(
                    const TruthOrDareKindChosen(TruthOrDareKind.truth),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text('Truth'),
                ),
              ),
              const SizedBox(width: Spacing.xl),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => bloc.add(
                    const TruthOrDareKindChosen(TruthOrDareKind.dare),
                  ),
                  icon: const Icon(Icons.local_fire_department_rounded),
                  label: const Text('Dare'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
