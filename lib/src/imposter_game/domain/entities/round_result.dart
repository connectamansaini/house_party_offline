import 'package:freezed_annotation/freezed_annotation.dart';

part 'round_result.freezed.dart';

/// Which side won a round.
enum WinningSide { civilian, imposter }

/// The outcome of a resolved round, including per-player score changes to
/// apply to cumulative totals.
@freezed
abstract class RoundResult with _$RoundResult {
  const factory RoundResult({
    required WinningSide winningSide,

    /// The player the group voted out this round.
    required String votedOutId,

    /// True only when a caught imposter guessed the secret word to steal the
    /// win.
    required bool imposterGuessedRight,

    /// Points to add to each player's cumulative score (0 for the losing
    /// side).
    required Map<String, int> scoreDeltas,
  }) = _RoundResult;
}
