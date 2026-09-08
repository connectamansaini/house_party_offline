import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';

part 'most_likely_to_session.freezed.dart';

/// The live state of an in-progress match: the roster, each player's score,
/// the shuffled prompt deck, and how many rounds the match runs for.
@freezed
abstract class MostLikelyToSession with _$MostLikelyToSession {
  const factory MostLikelyToSession({
    required List<MostLikelyToPlayer> players,
    required Map<String, int> scores,
    required List<String> deck,
    required int promptIndex,
    required int totalRounds,
  }) = _MostLikelyToSession;

  const MostLikelyToSession._();

  /// The prompt currently on screen. The deck loops (via modulo) if the host
  /// picked more rounds than there are bundled prompts.
  String get currentPrompt => deck[promptIndex % deck.length];

  /// The match ends once every round has been scored.
  bool get isOver => promptIndex >= totalRounds;

  int get topScore => scores.values.fold(0, max);

  /// Everyone sharing the top score. Empty if nobody scored at all.
  List<MostLikelyToPlayer> get leaders => topScore == 0
      ? const []
      : players.where((p) => scores[p.id] == topScore).toList();

  /// Null when the top score is shared (a tie) or nobody scored.
  MostLikelyToPlayer? get winner => leaders.length == 1 ? leaders.first : null;

  /// Roster ordered by score, highest first; ties keep roster order.
  List<MostLikelyToPlayer> get standings {
    // List.sort isn't guaranteed stable, so break ties on roster position.
    return List<MostLikelyToPlayer>.of(players)..sort((a, b) {
      final byScore = (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0);
      if (byScore != 0) return byScore;
      return players.indexOf(a).compareTo(players.indexOf(b));
    });
  }
}
