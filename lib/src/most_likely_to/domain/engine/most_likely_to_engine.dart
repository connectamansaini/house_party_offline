import 'dart:math';

import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_session.dart';

/// Pure game rules for Most Likely To. No Flutter/BLoC/IO so dealing and
/// scoring are fully unit-testable. Randomness is injected via [Random].
class MostLikelyToEngine {
  const MostLikelyToEngine();

  /// Shuffles [prompts] into a deck, zeroes every score, and fixes the match
  /// length at [MostLikelyToConfig.roundCount].
  MostLikelyToSession deal(
    List<MostLikelyToPlayer> players,
    MostLikelyToConfig config,
    List<String> prompts, {
    Random? rng,
  }) {
    if (players.length < MostLikelyToConfig.minPlayers) {
      throw ArgumentError(
        'Need at least ${MostLikelyToConfig.minPlayers} players.',
      );
    }
    if (prompts.isEmpty) {
      throw ArgumentError('Need at least one prompt.');
    }
    final deck = List<String>.of(prompts)..shuffle(rng ?? Random());
    return MostLikelyToSession(
      players: players,
      scores: {for (final p in players) p.id: 0},
      deck: deck,
      promptIndex: 0,
      totalRounds: config.roundCount,
    );
  }

  /// Awards a point to every player in [votedIds] (the group pointed at
  /// them — several ids means a tie) and advances to the next prompt.
  MostLikelyToSession applyRound(
    MostLikelyToSession session,
    Set<String> votedIds,
  ) {
    final scores = {...session.scores};
    for (final id in votedIds) {
      scores[id] = (scores[id] ?? 0) + 1;
    }
    return session.copyWith(
      scores: scores,
      promptIndex: session.promptIndex + 1,
    );
  }
}
