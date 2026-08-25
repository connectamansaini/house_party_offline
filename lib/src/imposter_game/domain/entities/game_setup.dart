import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';

part 'game_setup.freezed.dart';

/// The complete, validated input to a game: who is playing and the chosen
/// settings. Produced by the setup flow and consumed by the game FSM.
@freezed
abstract class GameSetup with _$GameSetup {
  const factory GameSetup({
    required List<Player> players,
    required GameConfig config,
  }) = _GameSetup;
}
