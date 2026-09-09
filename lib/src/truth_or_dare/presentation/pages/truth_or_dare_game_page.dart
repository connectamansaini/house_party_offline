import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_motion.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/engine/truth_or_dare_engine.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/bloc/truth_or_dare_game_bloc.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/widgets/choose_view.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/widgets/game_over_view.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/widgets/prompt_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Single-route host for a whole Truth or Dare match.
class TruthOrDareGamePage extends StatelessWidget {
  const TruthOrDareGamePage({required this.setup, super.key});

  final TruthOrDareSetup setup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TruthOrDareGameBloc(
        setup: setup,
        engine: getIt<TruthOrDareEngine>(),
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
    return BlocBuilder<TruthOrDareGameBloc, TruthOrDareGameState>(
      builder: (context, state) {
        final isOver = state.session.isOver;
        final turn = state.session.turnsPlayed;
        return PopScope(
          canPop: isOver,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final leave = await _confirmQuit(context);
            if (leave && context.mounted) context.go(AppRoutes.home);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(isOver ? 'Game over' : 'Truth or Dare'),
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
                duration: AppMotion.base,
                transitionBuilder: AppMotion.fadeRise,
                child: isOver
                    ? TruthOrDareGameOverView(
                        key: const ValueKey('over'),
                        session: state.session,
                      )
                    : state.isChoosing
                    ? ChooseView(key: ValueKey('choose-$turn'), state: state)
                    : PromptView(key: ValueKey('prompt-$turn'), state: state),
              ),
            ),
          ),
        );
      },
    );
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
