import 'dart:math';

import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_session.dart';

/// Pure game rules for Heads Up. No Flutter/BLoC/IO/timers so dealing,
/// drawing and scoring are fully unit-testable. Randomness is injected via
/// [Random]; the clock lives in the bloc.
class HeadsUpEngine {
  const HeadsUpEngine();

  /// Shuffles [words] into a deck, zeroes every score, and fixes the match
  /// length at [HeadsUpConfig.roundCount] turns per player.
  HeadsUpSession deal(
    List<HeadsUpPlayer> players,
    HeadsUpConfig config,
    List<String> words, {
    Random? rng,
  }) {
    if (players.length < HeadsUpConfig.minPlayers) {
      throw ArgumentError('Need at least ${HeadsUpConfig.minPlayers} players.');
    }
    if (words.isEmpty) {
      throw ArgumentError('Need at least one word.');
    }
    return HeadsUpSession(
      players: players,
      scores: {for (final p in players) p.id: 0},
      deck: List<String>.of(words)..shuffle(rng ?? Random()),
      deckIndex: 0,
      turnsPlayed: 0,
      roundCount: config.roundCount,
    );
  }

  /// Takes the next word off the deck. The deck loops (via modulo) if a
  /// match runs longer than the words the host picked.
  ({HeadsUpSession session, String word}) draw(HeadsUpSession session) => (
    session: session.copyWith(deckIndex: session.deckIndex + 1),
    word: session.deck[session.deckIndex % session.deck.length],
  );

  /// Scores a guess for the current player: a point if it was correct.
  HeadsUpSession judge(HeadsUpSession session, {required bool correct}) {
    if (!correct) return session;
    final id = session.currentPlayer.id;
    return session.copyWith(
      scores: {...session.scores, id: (session.scores[id] ?? 0) + 1},
    );
  }

  /// The clock ran out: the turn passes on.
  HeadsUpSession endTurn(HeadsUpSession session) =>
      session.copyWith(turnsPlayed: session.turnsPlayed + 1);
}
