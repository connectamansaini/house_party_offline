import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';

/// A participant in a game. Pure domain object — no persistence concerns here.
@freezed
abstract class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    @Default(0) int cumulativeScore,
  }) = _Player;

  const Player._();

  /// Returns a copy with [delta] added to the running score.
  Player addScore(int delta) =>
      copyWith(cumulativeScore: cumulativeScore + delta);
}
