import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/core/design/app_motion.dart';
import 'package:house_party_offline/core/design/app_radii.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/core/widgets/selectable_player_tile.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_night_step.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_event.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_night_card.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_role_visuals.dart';

/// Host-run night: a teleprompter for the narrator. A rail across the top
/// tracks the night's beats, a card carries the line to read out, and the
/// list below records what the waking players pointed at — so the phone
/// never goes round the room after the roles are dealt.
class MafiaHostNightView extends StatelessWidget {
  const MafiaHostNightView({required this.state, super.key});

  final MafiaHostNight state;

  @override
  Widget build(BuildContext context) {
    final investigating = state.investigationReveal != null;
    final Widget body;
    if (investigating) {
      body = _Investigation(text: state.investigationReveal!);
    } else if (state.step == MafiaNightStep.sleep) {
      body = _Sleep(state: state);
    } else {
      body = _Step(state: state);
    }

    return Column(
      children: [
        _StepRail(steps: state.steps, index: state.stepIndex),
        Expanded(
          // Each beat arrives rather than snapping, but the rail above
          // stays put so the host keeps their place.
          child: AnimatedSwitcher(
            duration: AppMotion.base,
            transitionBuilder: AppMotion.fadeRise,
            child: KeyedSubtree(
              key: ValueKey('${state.stepIndex}-$investigating'),
              child: body,
            ),
          ),
        ),
      ],
    );
  }
}

/// Tonight's beats as a progress bar: one segment per waking role, coloured
/// by that role, filled once it is done. Lets the host see at a glance what
/// is left to call.
class _StepRail extends StatelessWidget {
  const _StepRail({required this.steps, required this.index});

  final List<MafiaNightStep> steps;
  final int index;

  @override
  Widget build(BuildContext context) {
    // The opening "close your eyes" is not a beat anyone acts on.
    final acting = steps.skip(1).toList();
    if (acting.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.x5l,
        Spacing.md,
        Spacing.x5l,
        Spacing.xs,
      ),
      child: Row(
        children: [
          for (var i = 0; i < acting.length; i++) ...[
            if (i > 0) const SizedBox(width: Spacing.md),
            Expanded(
              child: _RailSegment(
                step: acting[i],
                // Segment i sits at step index i + 1, after the sleep.
                done: index > i + 1,
                current: index == i + 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RailSegment extends StatelessWidget {
  const _RailSegment({
    required this.step,
    required this.done,
    required this.current,
  });

  final MafiaNightStep step;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppColors.accentOf(roleVisual(step.role!).gradient);
    final ink = AppColors.legible(accent, theme.brightness);

    final barColor = current
        ? accent
        : done
        ? accent.withValues(alpha: 0.45)
        : scheme.outlineVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: AppMotion.base,
          curve: AppMotion.curve,
          height: 3,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(AppRadii.xs),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          step.role!.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: current ? ink : scheme.onSurfaceVariant,
            fontWeight: current ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// The opening beat: the whole screen is one instruction, so it gets the
/// full moment treatment.
class _Sleep extends StatelessWidget {
  const _Sleep({required this.state});

  final MafiaHostNight state;

  @override
  Widget build(BuildContext context) {
    final host = state.session.host;
    return _Frame(
      body: Center(
        child: SingleChildScrollView(
          child: MomentCard(
            mood: MomentMood.recap,
            gradient: AppColors.nightGradient,
            icon: MomentIcon.moon,
            eyebrow: 'READ ALOUD',
            headline: MafiaNightStep.sleep.announcement,
            subtitle: MafiaNightStep.sleep.instruction,
            footnote: host == null
                ? null
                : '${host.name} is narrating — keep the phone.',
          ),
        ),
      ),
      button: FilledButton.icon(
        onPressed: () =>
            context.read<MafiaGameBloc>().add(const NightActionConfirmed()),
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(MafiaNightStep.sleep.confirmLabel),
      ),
    );
  }
}

/// One waking role: the line to read, who should have their eyes open, and
/// the list to record their choice.
class _Step extends StatelessWidget {
  const _Step({required this.state});

  final MafiaHostNight state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MafiaGameBloc>();
    final session = state.session;
    final step = state.step;
    final role = step.role!;
    final selected = state.selectedId;
    final selectedName = selected == null
        ? null
        : session.playerOf(selected).name;

    return _Frame(
      header: MafiaNightCard(
        role: role,
        eyebrow: 'READ ALOUD',
        headline: step.announcement,
        subtitle: step.instruction,
        // The host's cheat sheet: who should have their eyes open.
        chip:
            'Awake: '
            '${session.livingWithRole(role).map((p) => p.name).join(', ')}',
        chipIcon: Icons.visibility_outlined,
      ),
      body: ListView(
        // Matches the script card's inset so the column has one edge.
        padding: const EdgeInsets.fromLTRB(
          Spacing.x5l,
          Spacing.x3l,
          Spacing.x5l,
          Spacing.x5l,
        ),
        children: [
          for (final p in _candidates(state))
            Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: SelectablePlayerTile(
                name: p.name,
                selected: p.id == selected,
                accentGradient: roleVisual(role).gradient,
                onTap: () => bloc.add(NightTargetSelected(p.id)),
              ),
            ),
        ],
      ),
      button: FilledButton.icon(
        onPressed: selected == null
            ? null
            : () => bloc.add(const NightActionConfirmed()),
        icon: Icon(_confirmIcon(step)),
        label: Text(
          selectedName == null
              ? step.confirmLabel
              : step.confirmWith(selectedName),
        ),
      ),
    );
  }

  static IconData _confirmIcon(MafiaNightStep step) => switch (step) {
    MafiaNightStep.mafia => Icons.mode_night_rounded,
    MafiaNightStep.doctor => Icons.health_and_safety_rounded,
    MafiaNightStep.detective => Icons.search_rounded,
    MafiaNightStep.sleep => Icons.play_arrow_rounded,
  };

  /// Who this role may pick tonight.
  static List<MafiaPlayer> _candidates(MafiaHostNight state) {
    final session = state.session;
    return switch (state.step) {
      // The mafia can't eat their own.
      MafiaNightStep.mafia => [
        for (final p in session.livingPlayers)
          if (!session.roleOf(p.id).isMafia) p,
      ],
      MafiaNightStep.doctor => [
        for (final p in session.livingPlayers)
          if (session.config.doctorSelfSave ||
              session.roleOf(p.id) != MafiaRole.doctor)
            p,
      ],
      // A detective checking themselves would learn nothing.
      MafiaNightStep.detective => [
        for (final p in session.livingPlayers)
          if (session.roleOf(p.id) != MafiaRole.detective) p,
      ],
      MafiaNightStep.sleep => session.livingPlayers,
    };
  }
}

/// The detective's answer, for the host to show them and nobody else.
class _Investigation extends StatelessWidget {
  const _Investigation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _Frame(
      body: Center(
        child: SingleChildScrollView(
          child: MomentCard(
            mood: MomentMood.reveal,
            gradient: AppColors.civilianGradient,
            icon: MomentIcon.magnifier,
            eyebrow: 'INVESTIGATION',
            kicker: 'The detective learns',
            headline: text,
            hint:
                'Show this to the detective only, then tell them to '
                'close their eyes.',
          ),
        ),
      ),
      button: FilledButton.icon(
        onPressed: () =>
            context.read<MafiaGameBloc>().add(const NightInvestigationSeen()),
        icon: const Icon(Icons.check_rounded),
        label: const Text('Done — carry on'),
      ),
    );
  }
}

/// Shared spacing for a host screen: an optional header, a body that takes
/// the slack, and a full-width action pinned above the system inset.
class _Frame extends StatelessWidget {
  const _Frame({required this.body, required this.button, this.header});

  final Widget? header;
  final Widget body;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.x5l,
              Spacing.md,
              Spacing.x5l,
              0,
            ),
            child: header,
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: header == null ? Spacing.x5l : 0,
            ),
            child: body,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            Spacing.x5l,
            Spacing.md,
            Spacing.x5l,
            Spacing.x3l + MediaQuery.of(context).padding.bottom,
          ),
          child: SizedBox(width: double.infinity, child: button),
        ),
      ],
    );
  }
}
