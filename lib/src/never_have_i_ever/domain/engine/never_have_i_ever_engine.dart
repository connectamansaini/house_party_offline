import 'dart:math';

import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_session.dart';

/// Pure game rules for Never Have I Ever. No Flutter/BLoC/IO so dealing and
/// elimination are fully unit-testable. Randomness is injected via [Random].
class NeverHaveIEverEngine {
  const NeverHaveIEverEngine();

  /// Shuffles [prompts] into a deck and gives every player
  /// [NeverHaveIEverConfig.livesPerPlayer] lives.
  NeverHaveIEverSession deal(
    List<NeverHaveIEverPlayer> players,
    NeverHaveIEverConfig config,
    List<String> prompts, {
    Random? rng,
  }) {
    if (players.length < NeverHaveIEverConfig.minPlayers) {
      throw ArgumentError(
        'Need at least ${NeverHaveIEverConfig.minPlayers} players.',
      );
    }
    if (prompts.isEmpty) {
      throw ArgumentError('Need at least one prompt.');
    }
    final deck = List<String>.of(prompts)..shuffle(rng ?? Random());
    return NeverHaveIEverSession(
      players: players,
      lives: {for (final p in players) p.id: config.livesPerPlayer},
      deck: deck,
      promptIndex: 0,
    );
  }

  /// Docks a life from every player in [matchedIds] (they've "done" the
  /// current prompt) and advances to the next one.
  NeverHaveIEverSession applyRound(
    NeverHaveIEverSession session,
    Set<String> matchedIds,
  ) {
    final lives = {...session.lives};
    for (final id in matchedIds) {
      final remaining = lives[id] ?? 0;
      lives[id] = remaining > 0 ? remaining - 1 : 0;
    }
    return session.copyWith(
      lives: lives,
      promptIndex: session.promptIndex + 1,
    );
  }
}
