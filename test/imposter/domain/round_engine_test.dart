import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/domain/engine/round_engine.dart';
import 'package:house_party_offline/src/imposter/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter/domain/entities/role.dart';
import 'package:house_party_offline/src/imposter/domain/entities/round_result.dart';
import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';

void main() {
  const engine = RoundEngine();

  const pack = WordPack(
    id: 'foods',
    name: 'Foods',
    category: 'Food',
    words: ['Pizza', 'Sushi', 'Tacos', 'Ramen'],
  );

  List<Player> makePlayers(int n) => [
    for (var i = 0; i < n; i++) Player(id: 'p$i', name: 'Player $i'),
  ];

  GameConfig config({
    int imposterCount = 1,
    bool hint = false,
    int crewPoints = 1,
    int imposterPoints = 2,
  }) => GameConfig(
    pack: pack,
    imposterCount: imposterCount,
    categoryHintEnabled: hint,
    crewWinPoints: crewPoints,
    imposterWinPoints: imposterPoints,
  );

  group('assignRoles', () {
    test('assigns exactly imposterCount imposters and a valid secret word', () {
      final players = makePlayers(5);
      final a = engine.assignRoles(
        players,
        config(imposterCount: 2),
        rng: Random(1),
      );

      expect(a.imposterIds.length, 2);
      expect(pack.words, contains(a.secretWord));
      expect(a.rolesByPlayerId.length, 5);
      // Every player has a role; imposters are ImposterRole, others CrewRole.
      for (final p in players) {
        final role = a.roleOf(p.id);
        if (a.imposterIds.contains(p.id)) {
          expect(role, isA<ImposterRole>());
        } else {
          expect(role, isA<CrewRole>());
          expect((role as CrewRole).secretWord, a.secretWord);
        }
      }
    });

    test('is deterministic for a fixed seed', () {
      final players = makePlayers(6);
      final a = engine.assignRoles(players, config(), rng: Random(42));
      final b = engine.assignRoles(players, config(), rng: Random(42));
      expect(a, equals(b));
    });

    test('crew see the category hint only when enabled', () {
      final players = makePlayers(4);

      final off = engine.assignRoles(players, config(hint: false), rng: Random(3));
      final crewOff =
          off.rolesByPlayerId.values.whereType<CrewRole>().first;
      expect(crewOff.categoryHint, isNull);

      final on = engine.assignRoles(players, config(hint: true), rng: Random(3));
      final crewOn = on.rolesByPlayerId.values.whereType<CrewRole>().first;
      expect(crewOn.categoryHint, pack.category);
    });

    test('imposter sees the hint only when enabled and never the word', () {
      final players = makePlayers(4);

      final on = engine.assignRoles(players, config(hint: true), rng: Random(7));
      final impOn = on.rolesByPlayerId.values.whereType<ImposterRole>().first;
      expect(impOn.categoryHint, pack.category);

      final off =
          engine.assignRoles(players, config(hint: false), rng: Random(7));
      final impOff =
          off.rolesByPlayerId.values.whereType<ImposterRole>().first;
      expect(impOff.categoryHint, isNull);
    });

    test('rejects fewer than 2 players', () {
      expect(
        () => engine.assignRoles(makePlayers(1), config()),
        throwsArgumentError,
      );
    });

    test('rejects imposterCount < 1 or >= player count', () {
      final players = makePlayers(4);
      expect(
        () => engine.assignRoles(players, config(imposterCount: 0)),
        throwsArgumentError,
      );
      expect(
        () => engine.assignRoles(players, config(imposterCount: 4)),
        throwsArgumentError,
      );
    });

    test('rejects duplicate player ids', () {
      const dup = [
        Player(id: 'x', name: 'A'),
        Player(id: 'x', name: 'B'),
        Player(id: 'y', name: 'C'),
      ];
      expect(() => engine.assignRoles(dup, config()), throwsArgumentError);
    });

    test('rejects an empty word pack', () {
      const empty = WordPack(id: 'e', name: 'Empty', category: 'None', words: []);
      expect(
        () => engine.assignRoles(makePlayers(4), config().copyWith(pack: empty)),
        throwsArgumentError,
      );
    });
  });

  group('isGuessCorrect', () {
    test('normalizes case and surrounding/inner whitespace', () {
      expect(engine.isGuessCorrect('  pizza ', 'Pizza'), isTrue);
      expect(engine.isGuessCorrect('HOT  DOG', 'hot dog'), isTrue);
      expect(engine.isGuessCorrect('sushi', 'Ramen'), isFalse);
    });
  });

  group('resolveRound', () {
    // Fixed assignment: p0 is the imposter, secret word Pizza.
    final players = makePlayers(4);
    final assignment = engine.assignRoles(
      players,
      config(),
      rng: Random(1),
    );
    // Ensure we know who the imposter is for the scenarios below.
    late String imposterId;
    late String crewId;

    setUp(() {
      imposterId = assignment.imposterIds.first;
      crewId = assignment.rolesByPlayerId.keys
          .firstWhere((id) => !assignment.imposterIds.contains(id));
    });

    test('imposter caught with correct guess → imposter steals the win', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        imposterGuess: assignment.secretWord,
        config: config(imposterPoints: 2),
      );
      expect(r.winningSide, WinningSide.imposter);
      expect(r.imposterGuessedRight, isTrue);
      expect(r.scoreDeltas[imposterId], 2);
      expect(r.scoreDeltas[crewId], 0);
    });

    test('imposter caught with wrong guess → crew wins', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        imposterGuess: 'definitely wrong',
        config: config(crewPoints: 1),
      );
      expect(r.winningSide, WinningSide.crew);
      expect(r.imposterGuessedRight, isFalse);
      expect(r.scoreDeltas[crewId], 1);
      expect(r.scoreDeltas[imposterId], 0);
    });

    test('imposter caught with no guess → crew wins', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        config: config(),
      );
      expect(r.winningSide, WinningSide.crew);
      expect(r.imposterGuessedRight, isFalse);
    });

    test('crew member voted out → imposter wins, guess ignored', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: crewId,
        config: config(imposterPoints: 3),
      );
      expect(r.winningSide, WinningSide.imposter);
      expect(r.imposterGuessedRight, isFalse);
      expect(r.scoreDeltas[imposterId], 3);
      expect(r.scoreDeltas[crewId], 0);
    });

    test('score deltas cover every player', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        config: config(),
      );
      expect(r.scoreDeltas.keys.toSet(), assignment.rolesByPlayerId.keys.toSet());
    });
  });
}
