import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/engine/truth_or_dare_engine.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_kind.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/prompts.dart';

void main() {
  const engine = TruthOrDareEngine();
  const players = [
    TruthOrDarePlayer(id: 'p1', name: 'Ann'),
    TruthOrDarePlayer(id: 'p2', name: 'Bo'),
  ];
  const truths = ['t1', 't2'];
  const dares = ['d1'];

  group('deal', () {
    test('zeroes scores, shuffles both decks, fixes the round count', () {
      final session = engine.deal(
        players,
        const TruthOrDareConfig(roundCount: 2),
        truths: truths,
        dares: dares,
      );

      expect(session.scores, {'p1': 0, 'p2': 0});
      expect(session.truths.toSet(), truths.toSet());
      expect(session.dares, dares);
      expect(session.turnsPlayed, 0);
      expect(session.roundCount, 2);
      expect(session.totalTurns, 4);
      expect(session.currentPlayer.id, 'p1');
    });

    test('throws with too few players or an empty deck', () {
      expect(
        () => engine.deal(
          const [TruthOrDarePlayer(id: 'p1', name: 'Ann')],
          const TruthOrDareConfig(),
          truths: truths,
          dares: dares,
        ),
        throwsArgumentError,
      );
      expect(
        () => engine.deal(
          players,
          const TruthOrDareConfig(),
          truths: truths,
          dares: const [],
        ),
        throwsArgumentError,
      );
    });
  });

  group('draw', () {
    test('takes the next prompt of that kind and loops when exhausted', () {
      final dealt = engine.deal(
        players,
        const TruthOrDareConfig(),
        truths: truths,
        dares: dares,
      );

      final first = engine.draw(dealt, TruthOrDareKind.dare);
      final second = engine.draw(first.session, TruthOrDareKind.dare);

      expect(first.prompt, 'd1');
      expect(second.prompt, 'd1');
      expect(second.session.dareIndex, 2);
      expect(second.session.truthIndex, 0);
    });
  });

  group('resolve', () {
    test('a completed turn scores and passes the turn', () {
      final dealt = engine.deal(
        players,
        const TruthOrDareConfig(),
        truths: truths,
        dares: dares,
      );

      final after = engine.resolve(dealt, done: true);

      expect(after.scores, {'p1': 1, 'p2': 0});
      expect(after.turnsPlayed, 1);
      expect(after.currentPlayer.id, 'p2');
    });

    test('a skipped turn passes without scoring', () {
      final dealt = engine.deal(
        players,
        const TruthOrDareConfig(),
        truths: truths,
        dares: dares,
      );

      final after = engine.resolve(dealt, done: false);

      expect(after.scores, {'p1': 0, 'p2': 0});
      expect(after.currentPlayer.id, 'p2');
    });
  });

  group('TruthOrDareSession', () {
    test('rounds advance once every player has had a turn', () {
      final dealt = engine.deal(
        players,
        const TruthOrDareConfig(roundCount: 2),
        truths: truths,
        dares: dares,
      );

      final afterOne = engine.resolve(dealt, done: true);
      expect(afterOne.roundNumber, 1);

      final afterTwo = engine.resolve(afterOne, done: false);
      expect(afterTwo.roundNumber, 2);
      expect(afterTwo.isOver, isFalse);

      final afterFour = engine.resolve(
        engine.resolve(afterTwo, done: true),
        done: true,
      );
      expect(afterFour.isOver, isTrue);
      expect(afterFour.winner?.id, 'p1');
      expect(afterFour.standings.map((p) => p.id), ['p1', 'p2']);
    });

    test('a shared top score is a tie, and no points means no leaders', () {
      final dealt = engine.deal(
        players,
        const TruthOrDareConfig(roundCount: 1),
        truths: truths,
        dares: dares,
      );

      final tied = engine.resolve(
        engine.resolve(dealt, done: true),
        done: true,
      );
      expect(tied.winner, isNull);
      expect(tied.leaders.map((p) => p.id), ['p1', 'p2']);

      final nobody = engine.resolve(
        engine.resolve(dealt, done: false),
        done: false,
      );
      expect(nobody.leaders, isEmpty);
    });
  });

  group('prompts', () {
    test('spicy decks are supersets of mild', () {
      expect(
        truthsFor(TruthOrDareLevel.spicy),
        containsAll(truthsFor(TruthOrDareLevel.mild)),
      );
      expect(
        daresFor(TruthOrDareLevel.spicy).length,
        greaterThan(daresFor(TruthOrDareLevel.mild).length),
      );
    });
  });
}
