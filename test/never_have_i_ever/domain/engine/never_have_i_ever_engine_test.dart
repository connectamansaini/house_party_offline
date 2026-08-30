import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/engine/never_have_i_ever_engine.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';

void main() {
  const engine = NeverHaveIEverEngine();
  const players = [
    NeverHaveIEverPlayer(id: 'p1', name: 'Ann'),
    NeverHaveIEverPlayer(id: 'p2', name: 'Bo'),
    NeverHaveIEverPlayer(id: 'p3', name: 'Cy'),
  ];

  group('deal', () {
    test('gives every player the configured lives', () {
      final session = engine.deal(
        players,
        const NeverHaveIEverConfig(),
        const ['prompt one', 'prompt two'],
      );

      expect(session.lives, {'p1': 3, 'p2': 3, 'p3': 3});
      expect(session.promptIndex, 0);
      expect(session.deck.length, 2);
      expect(session.deck.toSet(), {'prompt one', 'prompt two'});
    });

    test('throws with too few players', () {
      expect(
        () => engine.deal(
          const [NeverHaveIEverPlayer(id: 'p1', name: 'Ann')],
          const NeverHaveIEverConfig(),
          const ['a prompt'],
        ),
        throwsArgumentError,
      );
    });

    test('throws with no prompts', () {
      expect(
        () => engine.deal(players, const NeverHaveIEverConfig(), const []),
        throwsArgumentError,
      );
    });
  });

  group('applyRound', () {
    test('docks a life from every matched player and advances the prompt', () {
      final dealt = engine.deal(
        players,
        const NeverHaveIEverConfig(livesPerPlayer: 2),
        const ['a', 'b'],
      );

      final after = engine.applyRound(dealt, {'p1', 'p2'});

      expect(after.lives, {'p1': 1, 'p2': 1, 'p3': 2});
      expect(after.promptIndex, 1);
    });

    test('never drops a player below zero lives', () {
      final dealt = engine.deal(
        players,
        const NeverHaveIEverConfig(livesPerPlayer: 1),
        const ['a'],
      );

      final onceEliminated = engine.applyRound(dealt, {'p1'});
      final again = engine.applyRound(onceEliminated, {'p1'});

      expect(again.lives['p1'], 0);
    });
  });

  group('NeverHaveIEverSession', () {
    test('currentPrompt loops via modulo once the deck is exhausted', () {
      final session = engine.deal(
        players,
        const NeverHaveIEverConfig(),
        const ['only prompt'],
      );

      final threeRoundsLater = session.copyWith(promptIndex: 3);
      expect(threeRoundsLater.currentPrompt, 'only prompt');
    });

    test('isOver and winner reflect a single survivor', () {
      final dealt = engine.deal(
        players,
        const NeverHaveIEverConfig(livesPerPlayer: 1),
        const ['a'],
      );

      final after = engine.applyRound(dealt, {'p1', 'p2'});

      expect(after.isOver, isTrue);
      expect(after.winner?.id, 'p3');
      expect(
        after.eliminatedPlayers.map((p) => p.id),
        containsAll(['p1', 'p2']),
      );
    });

    test('a simultaneous wipeout is a draw (no winner)', () {
      final dealt = engine.deal(
        players,
        const NeverHaveIEverConfig(livesPerPlayer: 1),
        const ['a'],
      );

      final after = engine.applyRound(dealt, {'p1', 'p2', 'p3'});

      expect(after.isOver, isTrue);
      expect(after.winner, isNull);
    });
  });
}
