import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/domain/engine/round_engine.dart';
import 'package:house_party_offline/src/imposter/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter/domain/entities/imposter_mode.dart';
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
    int civilianPoints = 1,
    int imposterPoints = 2,
    ImposterMode mode = ImposterMode.blank,
  }) => GameConfig(
    packs: const [pack],
    imposterCount: imposterCount,
    imposterMode: mode,
    categoryHintEnabled: hint,
    civilianWinPoints: civilianPoints,
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
      // Every player has a role; imposters are ImposterRole, others CivilianRole.
      for (final p in players) {
        final role = a.roleOf(p.id);
        if (a.imposterIds.contains(p.id)) {
          expect(role, isA<ImposterRole>());
        } else {
          expect(role, isA<CivilianRole>());
          expect((role as CivilianRole).secretWord, a.secretWord);
        }
      }
    });

    test('is deterministic for a fixed seed', () {
      final players = makePlayers(6);
      final a = engine.assignRoles(players, config(), rng: Random(42));
      final b = engine.assignRoles(players, config(), rng: Random(42));
      expect(a, equals(b));
    });

    test('civilian see the category hint only when enabled', () {
      final players = makePlayers(4);

      final off = engine.assignRoles(players, config(), rng: Random(3));
      final civilianOff = off.rolesByPlayerId.values
          .whereType<CivilianRole>()
          .first;
      expect(civilianOff.categoryHint, isNull);

      final on = engine.assignRoles(
        players,
        config(hint: true),
        rng: Random(3),
      );
      final civilianOn = on.rolesByPlayerId.values
          .whereType<CivilianRole>()
          .first;
      expect(civilianOn.categoryHint, pack.category);
    });

    test('imposter sees the hint only when enabled and never the word', () {
      final players = makePlayers(4);

      final on = engine.assignRoles(
        players,
        config(hint: true),
        rng: Random(7),
      );
      final impOn = on.rolesByPlayerId.values.whereType<ImposterRole>().first;
      expect(impOn.categoryHint, pack.category);

      final off = engine.assignRoles(players, config(), rng: Random(7));
      final impOff = off.rolesByPlayerId.values.whereType<ImposterRole>().first;
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

    test('rejects packs with no words', () {
      const empty = WordPack(
        id: 'e',
        name: 'Empty',
        category: 'None',
        words: [],
      );
      expect(
        () => engine.assignRoles(
          makePlayers(4),
          config().copyWith(packs: [empty]),
        ),
        throwsArgumentError,
      );
    });

    test('draws across multiple packs; hint matches the chosen word pack', () {
      const animals = WordPack(
        id: 'animals',
        name: 'Animals',
        category: 'Animal',
        words: ['Owl', 'Cat', 'Fox'],
      );
      final cfg = config(hint: true).copyWith(packs: [pack, animals]);

      // Across many seeds, the word always comes from one of the packs and the
      // civilian's category hint reflects that word's pack.
      for (var seed = 0; seed < 25; seed++) {
        final a = engine.assignRoles(makePlayers(4), cfg, rng: Random(seed));
        final fromFoods = pack.words.contains(a.secretWord);
        final fromAnimals = animals.words.contains(a.secretWord);
        expect(
          fromFoods ^ fromAnimals,
          isTrue,
          reason: '${a.secretWord} must belong to exactly one pack',
        );
        final civilian = a.rolesByPlayerId.values
            .whereType<CivilianRole>()
            .first;
        expect(civilian.categoryHint, fromFoods ? 'Food' : 'Animal');
      }
    });
  });

  group('imposter mode', () {
    test('blank mode gives the imposter no decoy word', () {
      final a = engine.assignRoles(
        makePlayers(4),
        config(),
        rng: Random(2),
      );
      final imposter = a.rolesByPlayerId.values.whereType<ImposterRole>().first;
      expect(imposter.decoyWord, isNull);
    });

    test('undercover gives a decoy word that differs from the secret', () {
      final a = engine.assignRoles(
        makePlayers(4),
        config(mode: ImposterMode.undercover),
        rng: Random(2),
      );
      final imposter = a.rolesByPlayerId.values.whereType<ImposterRole>().first;
      expect(imposter.decoyWord, isNotNull);
      expect(pack.words, contains(imposter.decoyWord));
      expect(imposter.decoyWord, isNot(a.secretWord));
    });

    test("undercover decoy stays within the secret word's category", () {
      const foods = WordPack(
        id: 'foods',
        name: 'Foods',
        category: 'Food',
        words: ['Pizza', 'Sushi'],
      );
      const animals = WordPack(
        id: 'animals',
        name: 'Animals',
        category: 'Animal',
        words: ['Owl', 'Cat'],
      );
      final a = engine.assignRoles(
        makePlayers(4),
        const GameConfig(
          packs: [foods, animals],
          imposterMode: ImposterMode.undercover,
        ),
        rng: Random(5),
      );
      final decoy = a.rolesByPlayerId.values
          .whereType<ImposterRole>()
          .first
          .decoyWord!;
      final secretIsFood = foods.words.contains(a.secretWord);
      final decoyIsFood = foods.words.contains(decoy);
      expect(
        decoyIsFood,
        secretIsFood,
        reason: 'decoy should come from the same category as the secret',
      );
    });

    test('single-word pool yields no decoy (falls back to blank)', () {
      const solo = WordPack(
        id: 'solo',
        name: 'Solo',
        category: 'One',
        words: ['OnlyWord'],
      );
      final a = engine.assignRoles(
        makePlayers(3),
        const GameConfig(packs: [solo], imposterMode: ImposterMode.undercover),
        rng: Random(1),
      );
      expect(
        a.rolesByPlayerId.values.whereType<ImposterRole>().first.decoyWord,
        isNull,
      );
    });
  });

  group('tallyVotes', () {
    test('eliminates the player with the most votes', () {
      final votedOut = engine.tallyVotes({
        'a': 'x',
        'b': 'x',
        'c': 'y',
      });
      expect(votedOut, 'x');
    });

    test('breaks a tie among the leaders using the rng', () {
      // x and y each get 1 vote; the tie is broken deterministically by seed.
      final result = engine.tallyVotes({'a': 'x', 'b': 'y'}, rng: Random(0));
      expect(['x', 'y'], contains(result));
    });

    test('throws on an empty ballot set', () {
      expect(() => engine.tallyVotes(const {}), throwsArgumentError);
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
    late String civilianId;

    setUp(() {
      imposterId = assignment.imposterIds.first;
      civilianId = assignment.rolesByPlayerId.keys.firstWhere(
        (id) => !assignment.imposterIds.contains(id),
      );
    });

    test('imposter caught with correct guess → imposter steals the win', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        imposterGuess: assignment.secretWord,
        config: config(),
      );
      expect(r.winningSide, WinningSide.imposter);
      expect(r.imposterGuessedRight, isTrue);
      expect(r.scoreDeltas[imposterId], 2);
      expect(r.scoreDeltas[civilianId], 0);
    });

    test('imposter caught with wrong guess → civilian wins', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        imposterGuess: 'definitely wrong',
        config: config(),
      );
      expect(r.winningSide, WinningSide.civilian);
      expect(r.imposterGuessedRight, isFalse);
      expect(r.scoreDeltas[civilianId], 1);
      expect(r.scoreDeltas[imposterId], 0);
    });

    test('imposter caught with no guess → civilian wins', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        config: config(),
      );
      expect(r.winningSide, WinningSide.civilian);
      expect(r.imposterGuessedRight, isFalse);
    });

    test('civilian member voted out → imposter wins, guess ignored', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: civilianId,
        config: config(imposterPoints: 3),
      );
      expect(r.winningSide, WinningSide.imposter);
      expect(r.imposterGuessedRight, isFalse);
      expect(r.scoreDeltas[imposterId], 3);
      expect(r.scoreDeltas[civilianId], 0);
    });

    test('score deltas cover every player', () {
      final r = engine.resolveRound(
        assignment: assignment,
        votedOutId: imposterId,
        config: config(),
      );
      expect(
        r.scoreDeltas.keys.toSet(),
        assignment.rolesByPlayerId.keys.toSet(),
      );
    });
  });
}
