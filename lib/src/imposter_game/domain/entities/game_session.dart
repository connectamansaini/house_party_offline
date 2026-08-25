import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';

part 'game_session.freezed.dart';

/// The evolving state of a full game across rounds: the roster (with running
/// scores), the chosen config, and which round is being played.
@freezed
abstract class GameSession with _$GameSession {
  const factory GameSession({
    required List<Player> players,
    required GameConfig config,
    @Default(1) int roundNumber,
  }) = _GameSession;

  const GameSession._();

  /// Players ordered by score, highest first — for the scoreboard.
  List<Player> get standings =>
      [...players]
        ..sort((a, b) => b.cumulativeScore.compareTo(a.cumulativeScore));
}
