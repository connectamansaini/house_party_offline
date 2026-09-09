import 'package:freezed_annotation/freezed_annotation.dart';

part 'truth_or_dare_player.freezed.dart';

/// A participant in a Truth or Dare match. Identity only — the score is
/// tracked by the session, not on the player.
@freezed
abstract class TruthOrDarePlayer with _$TruthOrDarePlayer {
  const factory TruthOrDarePlayer({
    required String id,
    required String name,
  }) = _TruthOrDarePlayer;
}
