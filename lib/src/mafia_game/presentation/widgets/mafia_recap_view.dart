import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';

/// Morning recap of what happened overnight.
class MafiaNightRecapView extends StatelessWidget {
  const MafiaNightRecapView({required this.state, super.key});

  final MafiaNightRecap state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final resolution = state.resolution;
    final reveal = session.config.revealRolesOnDeath;

    final Gradient gradient;
    final MomentIcon icon;
    final String headline;
    final String detail;

    if (resolution.someoneDied) {
      final victim = session.playerOf(resolution.killedId!);
      gradient = AppColors.mafiaGradient;
      icon = MomentIcon.dagger;
      headline = '${victim.name} was killed in the night';
      detail = reveal
          ? 'They were the ${session.roleOf(victim.id).label}.'
          : 'Their role stays a mystery.';
    } else if (resolution.someoneSaved) {
      gradient = AppColors.civilianGradient;
      icon = MomentIcon.shieldCross;
      headline = 'The doctor saved a life!';
      detail = 'The mafia struck, but nobody died.';
    } else {
      gradient = AppColors.nightGradient;
      icon = MomentIcon.moon;
      headline = 'A quiet night';
      detail = 'Everyone woke up safe.';
    }

    return _RecapScaffold(
      eyebrow: 'Night recap',
      gradient: gradient,
      icon: icon,
      headline: headline,
      detail: detail,
      aliveCount: session.aliveIds.length,
      buttonLabel: state.winner != null ? 'See result' : 'Start the day',
    );
  }
}

/// Recap of the daytime lynch.
class MafiaLynchRecapView extends StatelessWidget {
  const MafiaLynchRecapView({required this.state, super.key});

  final MafiaLynchRecap state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final reveal = session.config.revealRolesOnDeath;

    if (state.lynchedId == null) {
      return _RecapScaffold(
        eyebrow: 'Day recap',
        gradient: AppColors.nightGradient,
        icon: MomentIcon.gavel,
        headline: 'No one was lynched',
        detail: 'The town couldn’t agree.',
        aliveCount: session.aliveIds.length,
        buttonLabel: state.winner != null ? 'See result' : 'To the night',
      );
    }

    final victim = session.playerOf(state.lynchedId!);
    return _RecapScaffold(
      eyebrow: 'Day recap',
      gradient: AppColors.brandGradient,
      icon: MomentIcon.gavel,
      headline: '${victim.name} was lynched',
      detail: reveal
          ? 'They were the ${session.roleOf(victim.id).label}.'
          : 'Their role stays a mystery.',
      aliveCount: session.aliveIds.length,
      buttonLabel: state.winner != null ? 'See result' : 'To the night',
    );
  }
}

class _RecapScaffold extends StatelessWidget {
  const _RecapScaffold({
    required this.eyebrow,
    required this.gradient,
    required this.icon,
    required this.headline,
    required this.detail,
    required this.aliveCount,
    required this.buttonLabel,
  });

  final String eyebrow;
  final Gradient gradient;
  final MomentIcon icon;
  final String headline;
  final String detail;
  final int aliveCount;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: MomentCard(
                mood: MomentMood.recap,
                gradient: gradient,
                icon: icon,
                eyebrow: eyebrow,
                headline: headline,
                subtitle: detail,
                footnote: '$aliveCount players remain',
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () =>
                context.read<MafiaGameBloc>().add(const RecapContinued()),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
