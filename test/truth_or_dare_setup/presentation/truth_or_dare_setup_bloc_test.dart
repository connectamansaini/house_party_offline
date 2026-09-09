import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare_setup/presentation/bloc/truth_or_dare_setup_bloc.dart';

Future<TruthOrDareSetupState> _emitUntil(
  TruthOrDareSetupBloc bloc,
  TruthOrDareSetupEvent event,
  bool Function(TruthOrDareSetupState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  test('seeds the minimum roster with mild, three-round defaults', () {
    final bloc = TruthOrDareSetupBloc();
    expect(bloc.state.players.length, TruthOrDareConfig.minPlayers);
    expect(bloc.state.config.roundCount, 3);
    expect(bloc.state.config.level, TruthOrDareLevel.mild);
    expect(bloc.state.canStart, isTrue);
    bloc.close();
  });

  test('addPlayer is capped at maxPlayers', () async {
    final bloc = TruthOrDareSetupBloc();
    for (var i = 0; i < 20; i++) {
      bloc.add(const TruthOrDareSetupPlayerAdded());
    }
    await bloc.stream.firstWhere(
      (s) => s.players.length == TruthOrDareConfig.maxPlayers,
    );
    expect(bloc.state.players.length, TruthOrDareConfig.maxPlayers);
    await bloc.close();
  });

  test('removing below the minimum blocks starting', () async {
    final bloc = TruthOrDareSetupBloc();
    final firstId = bloc.state.players.first.id;

    final s = await _emitUntil(
      bloc,
      TruthOrDareSetupPlayerRemoved(firstId),
      (s) => s.players.length == TruthOrDareConfig.minPlayers - 1,
    );

    expect(s.canStart, isFalse);
    await bloc.close();
  });

  test('renamePlayer updates only the target', () async {
    final bloc = TruthOrDareSetupBloc();
    final id = bloc.state.players[1].id;

    final s = await _emitUntil(
      bloc,
      TruthOrDareSetupPlayerRenamed(id: id, name: 'Alice'),
      (s) => s.players[1].name == 'Alice',
    );

    expect(s.players[0].name, 'Player 1');
    await bloc.close();
  });

  test('round count clamps and level switches', () async {
    final bloc = TruthOrDareSetupBloc();

    final capped = await _emitUntil(
      bloc,
      const TruthOrDareSetupRoundCountChanged(99),
      (s) => s.config.roundCount == TruthOrDareConfig.maxRounds,
    );
    expect(capped.config.roundCount, TruthOrDareConfig.maxRounds);

    final spicy = await _emitUntil(
      bloc,
      const TruthOrDareSetupLevelChanged(TruthOrDareLevel.spicy),
      (s) => s.config.level == TruthOrDareLevel.spicy,
    );
    expect(spicy.buildSetup().config.level, TruthOrDareLevel.spicy);
    expect(spicy.buildSetup().config.roundCount, TruthOrDareConfig.maxRounds);

    await bloc.close();
  });
}
