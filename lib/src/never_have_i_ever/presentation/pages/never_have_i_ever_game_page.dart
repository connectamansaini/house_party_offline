import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/widgets/gradient_scaffold.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/engine/never_have_i_ever_engine.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/bloc/never_have_i_ever_game_bloc.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/widgets/game_over_view.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/widgets/prompt_reveal_view.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Single-route host for a whole Never Have I Ever match.
class NeverHaveIEverGamePage extends StatelessWidget {
  const NeverHaveIEverGamePage({required this.setup, super.key});

  final NeverHaveIEverSetup setup;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NeverHaveIEverGameBloc(
        setup: setup,
        engine: getIt<NeverHaveIEverEngine>(),
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
    return BlocBuilder<NeverHaveIEverGameBloc, NeverHaveIEverGameState>(
      builder: (context, state) {
        final isOver = state.session.isOver;
        return PopScope(
          canPop: isOver,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final leave = await _confirmQuit(context);
            if (leave && context.mounted) context.go(AppRoutes.home);
          },
          child: GradientScaffold(
            appBar: AppBar(
              title: Text(isOver ? 'Game over' : 'Never Have I Ever'),
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
                child: isOver
                    ? NeverHaveIEverGameOverView(
                        key: const ValueKey('over'),
                        session: state.session,
                      )
                    : PromptRevealView(
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
