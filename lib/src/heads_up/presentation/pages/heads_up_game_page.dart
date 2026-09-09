import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_motion.dart';
import 'package:house_party_offline/src/core/haptics/app_haptics.dart';
import 'package:house_party_offline/src/heads_up/domain/engine/heads_up_engine.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_setup.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_ticker.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';
import 'package:house_party_offline/src/heads_up/presentation/bloc/heads_up_game_bloc.dart';
import 'package:house_party_offline/src/heads_up/presentation/widgets/game_over_view.dart';
import 'package:house_party_offline/src/heads_up/presentation/widgets/play_view.dart';
import 'package:house_party_offline/src/heads_up/presentation/widgets/ready_view.dart';
import 'package:house_party_offline/src/heads_up/presentation/widgets/turn_summary_view.dart';
import 'package:house_party_offline/src/review/domain/review_gate.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Single-route host for a whole Heads Up match.
class HeadsUpGamePage extends StatelessWidget {
  const HeadsUpGamePage({required this.setup, super.key});

  final HeadsUpSetup setup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeadsUpGameBloc(
        setup: setup,
        engine: getIt<HeadsUpEngine>(),
        ticker: getIt<HeadsUpTicker>(),
        tilt: getIt<HeadsUpTiltSensor>(),
      ),
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
    return BlocListener<HeadsUpGameBloc, HeadsUpGameState>(
      // Each judged word is a light tap, a turn ending a reveal, the match
      // ending a heavy one.
      listenWhen: (prev, cur) =>
          prev.phase != cur.phase ||
          prev.turnGuesses.length != cur.turnGuesses.length,
      listener: (_, state) {
        switch (state.phase) {
          case HeadsUpPhase.over:
            AppHaptics.win();
            unawaited(getIt<ReviewGate>().onMatchCompleted());
          case HeadsUpPhase.summary:
            AppHaptics.reveal();
          case HeadsUpPhase.playing:
            AppHaptics.confirm();
          case HeadsUpPhase.ready:
          case HeadsUpPhase.countdown:
            break;
        }
      },
      child: BlocBuilder<HeadsUpGameBloc, HeadsUpGameState>(
        builder: (context, state) {
          final isOver = state.phase == HeadsUpPhase.over;
          return PopScope(
            canPop: isOver,
            onPopInvokedWithResult: (didPop, _) async {
              if (didPop) return;
              final leave = await _confirmQuit(context);
              if (leave && context.mounted) context.go(AppRoutes.home);
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(isOver ? 'Game over' : 'Heads Up'),
                automaticallyImplyLeading: false,
                actions: [
                  if (!isOver)
                    IconButton(
                      tooltip: 'Quit game',
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        final leave = await _confirmQuit(context);
                        if (leave && context.mounted) {
                          context.go(AppRoutes.home);
                        }
                      },
                    ),
                ],
              ),
              body: SafeArea(
                child: AnimatedSwitcher(
                  duration: AppMotion.base,
                  transitionBuilder: AppMotion.fadeRise,
                  child: _body(state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(HeadsUpGameState state) {
    final turn = state.session.turnsPlayed;
    return switch (state.phase) {
      HeadsUpPhase.ready => ReadyView(
        key: ValueKey('ready-$turn'),
        state: state,
      ),
      HeadsUpPhase.countdown || HeadsUpPhase.playing => PlayView(
        key: ValueKey('play-$turn'),
        state: state,
      ),
      HeadsUpPhase.summary => TurnSummaryView(
        key: ValueKey('summary-$turn'),
        state: state,
      ),
      HeadsUpPhase.over => HeadsUpGameOverView(
        key: const ValueKey('over'),
        session: state.session,
      ),
    };
  }

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
