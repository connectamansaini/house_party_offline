import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/selectable_player_tile.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/bloc/never_have_i_ever_game_bloc.dart';

/// The repeating core of a match: the current prompt, a multi-select roster
/// of who matches it, and a confirm button that docks lives and advances.
class PromptRevealView extends StatelessWidget {
  const PromptRevealView({required this.state, super.key});

  final NeverHaveIEverGameState state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final bloc = context.read<NeverHaveIEverGameBloc>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, 0),
          child: _PromptBanner(
            round: session.promptIndex + 1,
            prompt: session.currentPrompt,
          ),
        ),
        const SizedBox(height: Spacing.x3l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Who's done it?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, Spacing.md, 20, Spacing.md),
            itemCount: session.alivePlayers.length,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
            itemBuilder: (context, i) {
              final player = session.alivePlayers[i];
              final lives = session.lives[player.id] ?? 0;
              return SelectablePlayerTile(
                name: player.name,
                selected: state.selectedIds.contains(player.id),
                accentGradient: AppColors.confessionGradient,
                onTap: () => bloc.add(NeverHaveIEverPlayerToggled(player.id)),
                trailing: _LivesPips(lives: lives),
              );
            },
          ),
        ),
        if (session.eliminatedPlayers.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, Spacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Out: '
                '${session.eliminatedPlayers.map((p) => p.name).join(', ')}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
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
            onPressed: () => bloc.add(const NeverHaveIEverRoundConfirmed()),
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

class _PromptBanner extends StatelessWidget {
  const _PromptBanner({required this.round, required this.prompt});

  final int round;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.x7l,
        vertical: Spacing.x8l,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.confessionGradient,
        borderRadius: BorderRadius.circular(AppRadii.x6l),
        boxShadow: [
          BoxShadow(
            color: AppColors.confessionGradient.colors.first.withValues(
              alpha: 0.35,
            ),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Round $round',
            style: const TextStyle(fontFamily: 'Unbounded').copyWith(
              color: AppColors.onGradient.withValues(alpha: 0.75),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: Spacing.x4l),
          Text(
            prompt,
            style: const TextStyle(fontFamily: 'Unbounded').copyWith(
              color: AppColors.onGradient,
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LivesPips extends StatelessWidget {
  const _LivesPips({required this.lives});

  final int lives;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < lives; i++)
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
