import 'package:freezed_annotation/freezed_annotation.dart';

part 'heads_up_player.freezed.dart';

/// A participant in a Heads Up match. Identity only — the score is tracked
/// by the session, not on the player.
@freezed
abstract class HeadsUpPlayer with _$HeadsUpPlayer {
  const factory HeadsUpPlayer({required String id, required String name}) =
      _HeadsUpPlayer;
}
