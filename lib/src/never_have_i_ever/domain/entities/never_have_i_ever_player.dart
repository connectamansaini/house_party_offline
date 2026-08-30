import 'package:freezed_annotation/freezed_annotation.dart';

part 'never_have_i_ever_player.freezed.dart';

/// A participant in a Never Have I Ever match. Identity only — remaining
/// lives are tracked by the session, not on the player.
@freezed
abstract class NeverHaveIEverPlayer with _$NeverHaveIEverPlayer {
  const factory NeverHaveIEverPlayer({
    required String id,
    required String name,
  }) = _NeverHaveIEverPlayer;
}
