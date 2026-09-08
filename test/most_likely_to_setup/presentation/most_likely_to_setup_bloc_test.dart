import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/bloc/most_likely_to_setup_bloc.dart';

Future<MostLikelyToSetupState> _emitUntil(
  MostLikelyToSetupBloc bloc,
  MostLikelyToSetupEvent event,
  bool Function(MostLikelyToSetupState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  group('initial state', () {
    test('seeds the minimum default roster', () {
      final bloc = MostLikelyToSetupBloc();
      expect(bloc.state.players.length, MostLikelyToConfig.minPlayers);
      expect(
        bloc.state.players.map((p) => p.name),
        List.generate(
          MostLikelyToConfig.minPlayers,
          (i) => 'Player ${i + 1}',
        ),
      );
      expect(bloc.state.config.roundCount, 10);
      bloc.close();
    });
  });

  group('players', () {
    test('addPlayer appends up to the max', () async {
      final bloc = MostLikelyToSetupBloc();
      final before = bloc.state.players.length;

      final s = await _emitUntil(
        bloc,
        const MostLikelyToSetupPlayerAdded(),
        (s) => s.players.length == before + 1,
      );
      expect(s.players.length, before + 1);

      await bloc.close();
    });

    test('addPlayer is capped at maxPlayers', () async {
      final bloc = MostLikelyToSetupBloc();
      for (var i = 0; i < 20; i++) {
        bloc.add(const MostLikelyToSetupPlayerAdded());
      }
      await bloc.stream.firstWhere(
        (s) => s.players.length == MostLikelyToConfig.maxPlayers,
      );
      expect(bloc.state.players.length, MostLikelyToConfig.maxPlayers);

      await bloc.close();
    });

    test('removePlayer removes the target', () async {
      final bloc = MostLikelyToSetupBloc();
      final firstId = bloc.state.players.first.id;

      final s = await _emitUntil(
        bloc,
        MostLikelyToSetupPlayerRemoved(firstId),
        (s) => s.players.length == MostLikelyToConfig.minPlayers - 1,
      );

      expect(s.players.any((p) => p.id == firstId), isFalse);
      expect(s.canStart, isFalse);
      await bloc.close();
    });

    test('renamePlayer updates only the target', () async {
      final bloc = MostLikelyToSetupBloc();
      final id = bloc.state.players[1].id;

      final s = await _emitUntil(
        bloc,
        MostLikelyToSetupPlayerRenamed(id: id, name: 'Alice'),
        (s) => s.players[1].name == 'Alice',
      );

      expect(s.players[1].name, 'Alice');
      expect(s.players[0].name, 'Player 1');

      await bloc.close();
    });
  });

  group('config', () {
    test('setRoundCount clamps within min/max', () async {
      final bloc = MostLikelyToSetupBloc();

      final capped = await _emitUntil(
        bloc,
        const MostLikelyToSetupRoundCountChanged(99),
        (s) => s.config.roundCount == MostLikelyToConfig.maxRounds,
      );
      expect(capped.config.roundCount, MostLikelyToConfig.maxRounds);

      final floored = await _emitUntil(
        bloc,
        const MostLikelyToSetupRoundCountChanged(0),
        (s) => s.config.roundCount == MostLikelyToConfig.minRounds,
      );
      expect(floored.config.roundCount, MostLikelyToConfig.minRounds);

      await bloc.close();
    });

    test('buildSetup produces a matching MostLikelyToSetup', () async {
      final bloc = MostLikelyToSetupBloc();
      await _emitUntil(
        bloc,
        const MostLikelyToSetupRoundCountChanged(15),
        (s) => s.config.roundCount == 15,
      );

      expect(bloc.state.canStart, isTrue);
      final setup = bloc.state.buildSetup();
      expect(setup.players.length, MostLikelyToConfig.minPlayers);
      expect(setup.config.roundCount, 15);

      await bloc.close();
    });
  });
}
