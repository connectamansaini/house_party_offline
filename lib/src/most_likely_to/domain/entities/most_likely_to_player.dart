import 'package:freezed_annotation/freezed_annotation.dart';

part 'most_likely_to_player.freezed.dart';

/// A participant in a Most Likely To match. Identity only — the score is
/// tracked by the session, not on the player.
@freezed
abstract class MostLikelyToPlayer with _$MostLikelyToPlayer {
  const factory MostLikelyToPlayer({
    required String id,
    required String name,
  }) = _MostLikelyToPlayer;
}
