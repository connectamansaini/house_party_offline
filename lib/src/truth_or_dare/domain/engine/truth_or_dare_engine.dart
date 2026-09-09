import 'dart:math';

import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_kind.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_session.dart';

/// Pure game rules for Truth or Dare. No Flutter/BLoC/IO so dealing, drawing
/// and scoring are fully unit-testable. Randomness is injected via [Random].
class TruthOrDareEngine {
  const TruthOrDareEngine();

  /// Shuffles both decks, zeroes every score, and fixes the match length at
  /// [TruthOrDareConfig.roundCount] rounds of one turn per player.
  TruthOrDareSession deal(
    List<TruthOrDarePlayer> players,
    TruthOrDareConfig config, {
    required List<String> truths,
    required List<String> dares,
    Random? rng,
  }) {
    if (players.length < TruthOrDareConfig.minPlayers) {
      throw ArgumentError(
        'Need at least ${TruthOrDareConfig.minPlayers} players.',
      );
    }
    if (truths.isEmpty || dares.isEmpty) {
      throw ArgumentError('Need at least one truth and one dare.');
    }
    final random = rng ?? Random();
    return TruthOrDareSession(
      players: players,
      scores: {for (final p in players) p.id: 0},
      truths: List<String>.of(truths)..shuffle(random),
      dares: List<String>.of(dares)..shuffle(random),
      truthIndex: 0,
      dareIndex: 0,
      turnsPlayed: 0,
      roundCount: config.roundCount,
    );
  }

  /// Takes the next prompt of [kind] off its deck. Decks loop (via modulo)
  /// if a match runs longer than the bundled prompt count.
  ({TruthOrDareSession session, String prompt}) draw(
    TruthOrDareSession session,
    TruthOrDareKind kind,
  ) {
    switch (kind) {
      case TruthOrDareKind.truth:
        return (
          session: session.copyWith(truthIndex: session.truthIndex + 1),
          prompt: session.truths[session.truthIndex % session.truths.length],
        );
      case TruthOrDareKind.dare:
        return (
          session: session.copyWith(dareIndex: session.dareIndex + 1),
          prompt: session.dares[session.dareIndex % session.dares.length],
        );
    }
  }

  /// Ends the current player's turn: a point if they went through with it,
  /// nothing if they skipped. Either way the turn passes on.
  TruthOrDareSession resolve(
    TruthOrDareSession session, {
    required bool done,
  }) {
    final scores = {...session.scores};
    if (done) {
      final id = session.currentPlayer.id;
      scores[id] = (scores[id] ?? 0) + 1;
    }
    return session.copyWith(
      scores: scores,
      turnsPlayed: session.turnsPlayed + 1,
    );
  }
}
