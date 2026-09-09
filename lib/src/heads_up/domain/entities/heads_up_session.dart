import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';

part 'heads_up_session.freezed.dart';

/// The live state of an in-progress match: the roster, scores, the shuffled
/// word deck with its draw position, and how far through the turn order the
/// match is. Everything inside a single turn (clock, current word) lives in
/// the bloc state — it doesn't outlive the turn.
@freezed
abstract class HeadsUpSession with _$HeadsUpSession {
  const factory HeadsUpSession({
    required List<HeadsUpPlayer> players,
    required Map<String, int> scores,
    required List<String> deck,
    required int deckIndex,
    required int turnsPlayed,
    required int roundCount,
  }) = _HeadsUpSession;

  const HeadsUpSession._();

  /// Whose turn it is to hold the phone. Turns rotate through the roster.
  HeadsUpPlayer get currentPlayer => players[turnsPlayed % players.length];

  /// One round = one turn for every player.
  int get roundNumber => turnsPlayed ~/ players.length + 1;

  int get totalTurns => players.length * roundCount;

  bool get isOver => turnsPlayed >= totalTurns;

  int get topScore => scores.values.fold(0, max);

  /// Everyone sharing the top score. Empty if nobody scored at all.
  List<HeadsUpPlayer> get leaders => topScore == 0
      ? const []
      : players.where((p) => scores[p.id] == topScore).toList();

  /// Null when the top score is shared (a tie) or nobody scored.
  HeadsUpPlayer? get winner => leaders.length == 1 ? leaders.first : null;

  /// Roster ordered by score, highest first; ties keep roster order.
  List<HeadsUpPlayer> get standings {
    // List.sort isn't guaranteed stable, so break ties on roster position.
    return List<HeadsUpPlayer>.of(players)..sort((a, b) {
      final byScore = (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0);
      if (byScore != 0) return byScore;
      return players.indexOf(a).compareTo(players.indexOf(b));
    });
  }
}
