import 'dart:math';

import 'package:house_party_offline/src/imposter_game/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/role.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/round_assignment.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/round_result.dart';

/// Pure game rules for the Imposter game. No Flutter, BLoC, or IO dependencies
/// so the full round lifecycle is unit-testable in isolation.
///
/// Randomness is injected via [Random] so tests can seed for determinism.
class RoundEngine {
  const RoundEngine();

  /// Deals roles for a new round.
  ///
  /// Picks a secret word from [GameConfig.packs], selects
  /// [GameConfig.imposterCount] imposters at random, and builds each player's
  /// [Role] honoring [GameConfig.categoryHintEnabled].
  ///
  /// Throws [ArgumentError] when the player list is too small, contains
  /// duplicate ids, the imposter count is out of range, or the pack has no
  /// words.
  RoundAssignment assignRoles(
    List<Player> players,
    GameConfig config, {
    Random? rng,
  }) {
    if (players.length < 2) {
      throw ArgumentError('Need at least 2 players to deal a round.');
    }
    final ids = players.map((p) => p.id).toSet();
    if (ids.length != players.length) {
      throw ArgumentError('Player ids must be unique.');
    }
    if (config.imposterCount < 1 || config.imposterCount >= players.length) {
      throw ArgumentError(
        'imposterCount must satisfy 1 <= count < playerCount '
        '(count=${config.imposterCount}, players=${players.length}).',
      );
    }

    // Flatten every word across the selected packs, keeping each word's own
    // category so a hint reflects the pack the chosen word came from.
    final entries = <({String word, String category})>[
      for (final pack in config.packs)
        for (final word in pack.words) (word: word, category: pack.category),
    ];
    if (entries.isEmpty) {
      throw ArgumentError('The selected word packs have no words.');
    }

    final random = rng ?? Random();
    final chosen = entries[random.nextInt(entries.length)];
    final secretWord = chosen.word;
    final hint = config.categoryHintEnabled ? chosen.category : null;

    // Undercover mode: pick a decoy word for the imposter — a different word,
    // preferring the same category, so it still reads as "related".
    final decoyWord = config.imposterMode.isUndercover
        ? _pickDecoy(entries, secretWord, chosen.category, random)
        : null;

    // Shuffle a copy of the players and take the first N as imposters.
    final shuffled = List<Player>.of(players)..shuffle(random);
    final imposterIds = shuffled
        .take(config.imposterCount)
        .map((p) => p.id)
        .toSet();

    final roles = <String, Role>{
      for (final player in players)
        player.id: imposterIds.contains(player.id)
            ? ImposterRole(categoryHint: hint, decoyWord: decoyWord)
            : CivilianRole(secretWord: secretWord, categoryHint: hint),
    };

    return RoundAssignment(
      rolesByPlayerId: roles,
      secretWord: secretWord,
      imposterIds: imposterIds,
    );
  }

  /// Whether the voted-out player was one of the imposters.
  bool wasImposterCaught(RoundAssignment assignment, String votedOutId) =>
      assignment.isImposter(votedOutId);

  /// Tallies secret ballots (voterId → suspectId) and returns the eliminated
  /// player: the suspect with the most votes. Ties are broken at random (via
  /// the injected [rng]) so no seating position is favoured.
  String tallyVotes(Map<String, String> ballots, {Random? rng}) {
    if (ballots.isEmpty) {
      throw ArgumentError('Cannot tally an empty ballot set.');
    }
    final counts = <String, int>{};
    for (final suspectId in ballots.values) {
      counts[suspectId] = (counts[suspectId] ?? 0) + 1;
    }
    final max = counts.values.reduce((a, b) => a > b ? a : b);
    final leaders = [
      for (final entry in counts.entries)
        if (entry.value == max) entry.key,
    ]..sort(); // stable order before the random pick keeps tests deterministic
    if (leaders.length == 1) return leaders.first;
    return leaders[(rng ?? Random()).nextInt(leaders.length)];
  }

  /// Case- and whitespace-insensitive comparison of an imposter's guess against
  /// the secret word.
  bool isGuessCorrect(String guess, String secretWord) =>
      _normalize(guess) == _normalize(secretWord);

  /// Resolves a round to a [RoundResult] with score deltas.
  ///
  /// Rules:
  /// - Imposter caught + correct guess  → imposters win (steal).
  /// - Imposter caught + wrong/no guess → civilian wins.
  /// - Imposter not caught              → imposters win.
  ///
  /// [imposterGuess] is only consulted when an imposter was caught; pass null
  /// when the civilian failed to catch an imposter.
  RoundResult resolveRound({
    required RoundAssignment assignment,
    required String votedOutId,
    required GameConfig config,
    String? imposterGuess,
  }) {
    final caught = wasImposterCaught(assignment, votedOutId);
    final guessedRight =
        caught &&
        imposterGuess != null &&
        isGuessCorrect(imposterGuess, assignment.secretWord);

    final imposterWins = !caught || guessedRight;
    final winningSide = imposterWins
        ? WinningSide.imposter
        : WinningSide.civilian;

    final points = imposterWins
        ? config.imposterWinPoints
        : config.civilianWinPoints;
    final winners = imposterWins
        ? assignment.imposterIds
        : assignment.rolesByPlayerId.keys
              .where((id) => !assignment.imposterIds.contains(id))
              .toSet();

    final deltas = <String, int>{
      for (final id in assignment.rolesByPlayerId.keys)
        id: winners.contains(id) ? points : 0,
    };

    return RoundResult(
      winningSide: winningSide,
      votedOutId: votedOutId,
      imposterGuessedRight: guessedRight,
      scoreDeltas: deltas,
    );
  }

  /// Chooses the imposter's decoy word: a word different from [secretWord],
  /// preferring one in the same [category]. Falls back to any different word,
  /// or null when the pool has only the secret word.
  String? _pickDecoy(
    List<({String word, String category})> entries,
    String secretWord,
    String category,
    Random random,
  ) {
    final sameCategory = [
      for (final e in entries)
        if (e.category == category && e.word != secretWord) e.word,
    ];
    final pool = sameCategory.isNotEmpty
        ? sameCategory
        : [
            for (final e in entries)
              if (e.word != secretWord) e.word,
          ];
    if (pool.isEmpty) return null;
    return pool[random.nextInt(pool.length)];
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
