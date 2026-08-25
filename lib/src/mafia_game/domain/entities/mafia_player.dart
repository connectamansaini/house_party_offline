import 'package:freezed_annotation/freezed_annotation.dart';

part 'mafia_player.freezed.dart';

/// A participant in a Mafia game. Identity only — alive/dead and role are
/// tracked by the game state, not on the player.
@freezed
abstract class MafiaPlayer with _$MafiaPlayer {
  const factory MafiaPlayer({required String id, required String name}) =
      _MafiaPlayer;
}
