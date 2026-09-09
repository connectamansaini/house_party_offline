import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';

part 'truth_or_dare_session.freezed.dart';

/// The live state of an in-progress match: the roster, scores, both
/// shuffled prompt decks with their draw positions, and how far through the
/// turn order the match is.
@freezed
abstract class TruthOrDareSession with _$TruthOrDareSession {
  const factory TruthOrDareSession({
    required List<TruthOrDarePlayer> players,
    required Map<String, int> scores,
    required List<String> truths,
    required List<String> dares,
    required int truthIndex,
    required int dareIndex,
    required int turnsPlayed,
    required int roundCount,
  }) = _TruthOrDareSession;

  const TruthOrDareSession._();

  /// Whose turn it is. Turns rotate through the roster in order.
  TruthOrDarePlayer get currentPlayer => players[turnsPlayed % players.length];

  /// One round = one turn for every player.
  int get roundNumber => turnsPlayed ~/ players.length + 1;

  int get totalTurns => players.length * roundCount;

  bool get isOver => turnsPlayed >= totalTurns;

  int get topScore => scores.values.fold(0, max);

  /// Everyone sharing the top score. Empty if nobody scored at all.
  List<TruthOrDarePlayer> get leaders => topScore == 0
      ? const []
      : players.where((p) => scores[p.id] == topScore).toList();

  /// Null when the top score is shared (a tie) or nobody scored.
  TruthOrDarePlayer? get winner => leaders.length == 1 ? leaders.first : null;

  /// Roster ordered by score, highest first; ties keep roster order.
  List<TruthOrDarePlayer> get standings {
    // List.sort isn't guaranteed stable, so break ties on roster position.
    return List<TruthOrDarePlayer>.of(players)..sort((a, b) {
      final byScore = (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0);
      if (byScore != 0) return byScore;
      return players.indexOf(a).compareTo(players.indexOf(b));
    });
  }
}
