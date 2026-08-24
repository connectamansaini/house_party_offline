import 'package:equatable/equatable.dart';

import 'package:house_party_offline/src/imposter/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter/domain/entities/player.dart';

/// The complete, validated input to a game: who is playing and the chosen
/// settings. Produced by the setup flow and consumed by the game FSM.
class GameSetup extends Equatable {
  const GameSetup({required this.players, required this.config});

  final List<Player> players;
  final GameConfig config;

  @override
  List<Object?> get props => [players, config];
}
