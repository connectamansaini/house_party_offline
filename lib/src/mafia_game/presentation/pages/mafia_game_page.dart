import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_bloc.dart';
import 'package:house_party_offline/src/mafia_game/presentation/bloc/mafia_game_state.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_day_vote_view.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_game_over_view.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_night_view.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_recap_view.dart';
import 'package:house_party_offline/src/mafia_game/presentation/widgets/mafia_role_reveal_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Single-route host for a whole Mafia match. The [MafiaGameBloc] FSM is
/// authoritative; the body swaps by phase so the OS back button can't corrupt
/// the game.
class MafiaGamePage extends StatelessWidget {
  const MafiaGamePage({required this.setup, super.key});

  final MafiaSetup setup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MafiaGameBloc(setup: setup, engine: getIt<MafiaEngine>()),
      child: const _GameScaffold(),
    );
  }
}

class _GameScaffold extends StatefulWidget {
  const _GameScaffold();

  @override
  State<_GameScaffold> createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<_GameScaffold> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MafiaGameBloc, MafiaGameState>(
      builder: (context, state) {
        final isOver = state is MafiaGameOver;
        return PopScope(
          canPop: isOver,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final leave = await _confirmQuit(context);
            if (leave && context.mounted) context.go(AppRoutes.home);
          },
          child: GradientScaffold(
            appBar: AppBar(
              title: Text(_title(state)),
              automaticallyImplyLeading: false,
              actions: [
                if (!isOver)
                  IconButton(
                    tooltip: 'Quit game',
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      final leave = await _confirmQuit(context);
                      if (leave && context.mounted) context.go(AppRoutes.home);
                    },
                  ),
              ],
            ),
            body: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _phase(state),
              ),
            ),
          ),
        );
      },
    );
  }

  String _title(MafiaGameState state) => switch (state) {
    MafiaRoleReveal() => 'Role reveal',
    MafiaNight() => 'Night ${state.session.nightNumber}',
    MafiaNightRecap() => 'Morning',
    MafiaDayVote() => 'Day ${state.session.nightNumber}',
    MafiaLynchRecap() => 'Verdict',
    MafiaGameOver() => 'Game over',
  };

  Widget _phase(MafiaGameState state) => switch (state) {
    MafiaRoleReveal() => MafiaRoleRevealView(
      key: const ValueKey('reveal'),
      state: state,
    ),
    MafiaNight() => MafiaNightView(key: const ValueKey('night'), state: state),
    MafiaNightRecap() => MafiaNightRecapView(
      key: const ValueKey('night-recap'),
      state: state,
    ),
    MafiaDayVote() => MafiaDayVoteView(
      key: const ValueKey('day'),
      state: state,
    ),
    MafiaLynchRecap() => MafiaLynchRecapView(
      key: const ValueKey('lynch-recap'),
      state: state,
    ),
    MafiaGameOver() => MafiaGameOverView(
      key: const ValueKey('over'),
      state: state,
    ),
  };

  Future<bool> _confirmQuit(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quit game?'),
        content: const Text('This match will end.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep playing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
