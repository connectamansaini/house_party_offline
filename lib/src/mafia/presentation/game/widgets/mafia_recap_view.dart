import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../mafia_game_bloc.dart';
import '../mafia_game_event.dart';
import '../mafia_game_state.dart';

/// Morning recap of what happened overnight.
class MafiaNightRecapView extends StatelessWidget {
  const MafiaNightRecapView({super.key, required this.state});

  final MafiaNightRecap state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final resolution = state.resolution;
    final reveal = session.config.revealRolesOnDeath;

    final Gradient gradient;
    final IconData icon;
    final String headline;
    final String detail;

    if (resolution.someoneDied) {
      final victim = session.playerOf(resolution.killedId!);
      gradient = AppColors.mafiaGradient;
      icon = Icons.dark_mode_rounded;
      headline = '${victim.name} was killed in the night';
      detail = reveal
          ? 'They were the ${session.roleOf(victim.id).label}.'
          : 'Their role stays a mystery.';
    } else if (resolution.someoneSaved) {
      gradient = AppColors.civilianGradient;
      icon = Icons.healing_rounded;
      headline = 'The doctor saved a life!';
      detail = 'The mafia struck, but nobody died.';
    } else {
      gradient = AppColors.nightGradient;
      icon = Icons.wb_twilight_rounded;
      headline = 'A quiet night';
      detail = 'Everyone woke up safe.';
    }

    return _RecapScaffold(
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
  const MafiaLynchRecapView({super.key, required this.state});

  final MafiaLynchRecap state;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final reveal = session.config.revealRolesOnDeath;

    if (state.lynchedId == null) {
      return _RecapScaffold(
        gradient: AppColors.nightGradient,
        icon: Icons.gavel_rounded,
        headline: 'No one was lynched',
        detail: 'The town couldn’t agree.',
        aliveCount: session.aliveIds.length,
        buttonLabel: state.winner != null ? 'See result' : 'To the night',
      );
    }

    final victim = session.playerOf(state.lynchedId!);
    return _RecapScaffold(
      gradient: AppColors.brandGradient,
      icon: Icons.gavel_rounded,
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
    required this.gradient,
    required this.icon,
    required this.headline,
    required this.detail,
    required this.aliveCount,
    required this.buttonLabel,
  });

  final Gradient gradient;
  final IconData icon;
  final String headline;
  final String detail;
  final int aliveCount;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 60, color: AppColors.onGradient),
                    const SizedBox(height: 16),
                    Text(
                      headline,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.onGradient,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detail,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.onGradient.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$aliveCount players remain',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.onGradient.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
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
