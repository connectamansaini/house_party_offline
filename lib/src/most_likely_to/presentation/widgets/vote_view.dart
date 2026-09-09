import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/prompt_card.dart';
import 'package:house_party_offline/src/core/widgets/selectable_player_tile.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/bloc/most_likely_to_game_bloc.dart';

/// The repeating core of a match: the current prompt, a roster to mark who
/// the group pointed at, and a confirm button that scores and advances.
class VoteView extends StatelessWidget {
  const VoteView({required this.state, super.key});

  final MostLikelyToGameState state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final bloc = context.read<MostLikelyToGameBloc>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, 0),
          child: PromptCard(
            eyebrow:
                'Round ${session.promptIndex + 1} of ${session.totalRounds}',
            text: session.currentPrompt,
            accent: AppColors.accentOf(AppColors.spotlightGradient),
          ),
        ),
        const SizedBox(height: Spacing.x3l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Who got the most fingers?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, Spacing.md),
            itemCount: session.players.length,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
            itemBuilder: (context, i) {
              final player = session.players[i];
              final score = session.scores[player.id] ?? 0;
              return SelectablePlayerTile(
                name: player.name,
                selected: state.selectedIds.contains(player.id),
                accentGradient: AppColors.spotlightGradient,
                onTap: () => bloc.add(MostLikelyToPlayerToggled(player.id)),
                trailing: _ScoreBadge(score: score),
              );
            },
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
            onPressed: () => bloc.add(const MostLikelyToRoundConfirmed()),
            child: Text(
              state.selectedIds.isEmpty
                  ? 'Nobody — next prompt'
                  : 'Confirm & continue',
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact running score, shown after each name in the roster.
class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: score > 0 ? scheme.primaryContainer : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        score == 1 ? '1 pt' : '$score pts',
        style: theme.textTheme.labelMedium?.copyWith(
          color: score > 0
              ? scheme.onPrimaryContainer
              : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
