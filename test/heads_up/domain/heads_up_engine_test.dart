import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/heads_up/domain/engine/heads_up_engine.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';

void main() {
  const engine = HeadsUpEngine();
  const players = [
    HeadsUpPlayer(id: 'p1', name: 'Ann'),
    HeadsUpPlayer(id: 'p2', name: 'Bo'),
  ];
  const words = ['cat', 'dog'];

  test('deal zeroes scores, shuffles the deck and fixes the length', () {
    final s = engine.deal(players, const HeadsUpConfig(roundCount: 2), words);

    expect(s.scores, {'p1': 0, 'p2': 0});
    expect(s.deck.toSet(), words.toSet());
    expect(s.totalTurns, 4);
    expect(s.currentPlayer.id, 'p1');
    expect(s.isOver, isFalse);
  });

  test('deal rejects too few players or no words', () {
    expect(
      () => engine.deal([players.first], const HeadsUpConfig(), words),
      throwsArgumentError,
    );
    expect(
      () => engine.deal(players, const HeadsUpConfig(), const []),
      throwsArgumentError,
    );
  });

  test('draw walks the deck and loops when exhausted', () {
    final dealt = engine.deal(players, const HeadsUpConfig(), words);

    final first = engine.draw(dealt);
    final second = engine.draw(first.session);
    final third = engine.draw(second.session);

    expect({first.word, second.word}, words.toSet());
    expect(third.word, first.word);
    expect(third.session.deckIndex, 3);
  });

  test('judge scores only correct guesses, for the current player', () {
    final dealt = engine.deal(players, const HeadsUpConfig(), words);

    final missed = engine.judge(dealt, correct: false);
    expect(missed.scores, {'p1': 0, 'p2': 0});

    final got = engine.judge(missed, correct: true);
    expect(got.scores, {'p1': 1, 'p2': 0});
  });

  test('endTurn rotates players and ends the match after every round', () {
    final dealt = engine.deal(players, const HeadsUpConfig(), words);

    final afterOne = engine.endTurn(dealt);
    expect(afterOne.currentPlayer.id, 'p2');
    expect(afterOne.isOver, isFalse);

    final afterTwo = engine.endTurn(afterOne);
    expect(afterTwo.isOver, isTrue);
  });

  test('standings, winner and ties follow the scores', () {
    final dealt = engine.deal(players, const HeadsUpConfig(), words);
    final annTwo = engine.judge(
      engine.judge(dealt, correct: true),
      correct: true,
    );
    final boTurn = engine.endTurn(annTwo);
    final boOne = engine.judge(boTurn, correct: true);

    expect(boOne.winner?.id, 'p1');
    expect(boOne.standings.map((p) => p.id), ['p1', 'p2']);

    final tied = engine.judge(boOne, correct: true);
    expect(tied.winner, isNull);
    expect(tied.leaders.length, 2);
    expect(dealt.leaders, isEmpty);
  });
}
