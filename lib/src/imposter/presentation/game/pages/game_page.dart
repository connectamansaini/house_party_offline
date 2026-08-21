import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../../app/router/router.dart';
import '../../../../core/widgets/gradient_scaffold.dart';
import '../../../domain/engine/round_engine.dart';
import '../../../domain/entities/game_setup.dart';
import '../game_bloc.dart';
import '../game_state.dart';
import '../widgets/discussion_view.dart';
import '../widgets/game_over_view.dart';
import '../widgets/imposter_guessing_view.dart';
import '../widgets/role_reveal_view.dart';
import '../widgets/round_result_view.dart';
import '../widgets/secret_voting_view.dart';
import '../widgets/voting_view.dart';

class GamePage extends StatelessWidget {
  const GamePage({required this.setup, super.key});

  final GameSetup setup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameBloc(setup: setup, engine: getIt<RoundEngine>()),
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
    // Keep the screen awake while the phone is passed around.
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final isOver = state is GameOver;
        return PopScope(
          canPop: isOver,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final leave = await _confirmQuit(context);
            if (leave && context.mounted) context.go(AppRoutes.home);
          },
          child: GradientScaffold(
            appBar: AppBar(
              title: Text(
                isOver ? 'Game over' : 'Round ${state.session.roundNumber}',
              ),
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
                child: _buildPhase(state),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhase(GameState state) {
    return switch (state) {
      RoleReveal() => RoleRevealView(
        key: const ValueKey('reveal'),
        state: state,
      ),
      Discussion() => DiscussionView(
        key: const ValueKey('discussion'),
        state: state,
      ),
      Voting() => VotingView(key: const ValueKey('voting'), state: state),
      SecretVoting() => SecretVotingView(
        key: const ValueKey('secret-voting'),
        state: state,
      ),
      ImposterGuessing() => ImposterGuessingView(
        key: const ValueKey('guessing'),
        state: state,
      ),
      RoundResultState() => RoundResultView(
        key: const ValueKey('result'),
        state: state,
      ),
      GameOver() => GameOverView(key: const ValueKey('over'), state: state),
    };
  }

  Future<bool> _confirmQuit(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quit game?'),
        content: const Text('Scores for this game will be lost.'),
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
