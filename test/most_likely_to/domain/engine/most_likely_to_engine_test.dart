import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';

void main() {
  const engine = MostLikelyToEngine();
  const players = [
    MostLikelyToPlayer(id: 'p1', name: 'Ann'),
    MostLikelyToPlayer(id: 'p2', name: 'Bo'),
    MostLikelyToPlayer(id: 'p3', name: 'Cy'),
  ];

  group('deal', () {
    test('zeroes every score and fixes the round count', () {
      final session = engine.deal(
        players,
        const MostLikelyToConfig(roundCount: 5),
        const ['prompt one', 'prompt two'],
      );

      expect(session.scores, {'p1': 0, 'p2': 0, 'p3': 0});
      expect(session.promptIndex, 0);
      expect(session.totalRounds, 5);
      expect(session.deck.length, 2);
      expect(session.deck.toSet(), {'prompt one', 'prompt two'});
    });

    test('throws with too few players', () {
      expect(
        () => engine.deal(
          const [
            MostLikelyToPlayer(id: 'p1', name: 'Ann'),
            MostLikelyToPlayer(id: 'p2', name: 'Bo'),
          ],
          const MostLikelyToConfig(),
          const ['a prompt'],
        ),
        throwsArgumentError,
      );
    });

    test('throws with no prompts', () {
      expect(
        () => engine.deal(players, const MostLikelyToConfig(), const []),
        throwsArgumentError,
      );
    });
  });

  group('applyRound', () {
    test('awards a point to every voted player and advances the prompt', () {
      final dealt = engine.deal(
        players,
        const MostLikelyToConfig(),
        const ['a', 'b'],
      );

      final after = engine.applyRound(dealt, {'p1', 'p2'});

      expect(after.scores, {'p1': 1, 'p2': 1, 'p3': 0});
      expect(after.promptIndex, 1);
    });

    test('an empty vote still advances the prompt', () {
      final dealt = engine.deal(
        players,
        const MostLikelyToConfig(),
        const ['a', 'b'],
      );

      final after = engine.applyRound(dealt, const {});

      expect(after.scores, dealt.scores);
      expect(after.promptIndex, 1);
    });
  });

  group('MostLikelyToSession', () {
    test('currentPrompt loops via modulo once the deck is exhausted', () {
      final session = engine.deal(
        players,
        const MostLikelyToConfig(),
        const ['only prompt'],
      );

      final threeRoundsLater = session.copyWith(promptIndex: 3);
      expect(threeRoundsLater.currentPrompt, 'only prompt');
    });

    test('isOver flips once every round has been played', () {
      final dealt = engine.deal(
        players,
        const MostLikelyToConfig(roundCount: 3),
        const ['a'],
      );

      final afterTwo = engine.applyRound(
        engine.applyRound(dealt, {'p1'}),
        {'p2'},
      );
      expect(afterTwo.isOver, isFalse);

      final afterThree = engine.applyRound(afterTwo, {'p1'});
      expect(afterThree.isOver, isTrue);
    });

    test('winner is the sole top scorer and standings rank by score', () {
      final dealt = engine.deal(
        players,
        const MostLikelyToConfig(roundCount: 3),
        const ['a'],
      );

      final after = engine.applyRound(
        engine.applyRound(engine.applyRound(dealt, {'p2'}), {'p2'}),
        {'p3'},
      );

      expect(after.topScore, 2);
      expect(after.winner?.id, 'p2');
      expect(after.standings.map((p) => p.id), ['p2', 'p3', 'p1']);
    });

    test('a shared top score is a tie (no winner, several leaders)', () {
      final dealt = engine.deal(
        players,
        const MostLikelyToConfig(roundCount: 3),
        const ['a'],
      );

      final after = engine.applyRound(dealt, {'p1', 'p3'});

      expect(after.winner, isNull);
      expect(after.leaders.map((p) => p.id), ['p1', 'p3']);
    });

    test('no points at all means no leaders', () {
      final dealt = engine.deal(
        players,
        const MostLikelyToConfig(roundCount: 3),
        const ['a'],
      );

      expect(dealt.leaders, isEmpty);
      expect(dealt.winner, isNull);
    });
  });
}
