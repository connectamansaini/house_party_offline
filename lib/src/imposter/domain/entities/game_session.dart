import 'package:equatable/equatable.dart';

import 'package:house_party_offline/src/imposter/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter/domain/entities/player.dart';

/// The evolving state of a full game across rounds: the roster (with running
/// scores), the chosen config, and which round is being played.
class GameSession extends Equatable {
  const GameSession({
    required this.players,
    required this.config,
    this.roundNumber = 1,
  });

  final List<Player> players;
  final GameConfig config;
  final int roundNumber;

  /// Players ordered by score, highest first — for the scoreboard.
  List<Player> get standings =>
      [...players]
        ..sort((a, b) => b.cumulativeScore.compareTo(a.cumulativeScore));

  GameSession copyWith({
    List<Player>? players,
    GameConfig? config,
    int? roundNumber,
  }) {
    return GameSession(
      players: players ?? this.players,
      config: config ?? this.config,
      roundNumber: roundNumber ?? this.roundNumber,
    );
  }

  @override
  List<Object?> get props => [players, config, roundNumber];
}
