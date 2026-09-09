import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/core/design/app_motion.dart';
import 'package:house_party_offline/src/core/widgets/app_scaffold.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/bloc/most_likely_to_game_bloc.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/widgets/game_over_view.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/widgets/vote_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Single-route host for a whole Most Likely To match.
class MostLikelyToGamePage extends StatelessWidget {
  const MostLikelyToGamePage({required this.setup, super.key});

  final MostLikelyToSetup setup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MostLikelyToGameBloc(
        setup: setup,
        engine: getIt<MostLikelyToEngine>(),
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
    return BlocBuilder<MostLikelyToGameBloc, MostLikelyToGameState>(
      builder: (context, state) {
        final isOver = state.session.isOver;
        return PopScope(
          canPop: isOver,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final leave = await _confirmQuit(context);
            if (leave && context.mounted) context.go(AppRoutes.home);
          },
          child: AppScaffold(
            appBar: AppBar(
              title: Text(isOver ? 'Game over' : 'Most Likely To'),
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
                    ? MostLikelyToGameOverView(
                        key: const ValueKey('over'),
                        session: state.session,
                      )
                    : VoteView(
                        key: ValueKey(state.session.promptIndex),
                        state: state,
                      ),
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
