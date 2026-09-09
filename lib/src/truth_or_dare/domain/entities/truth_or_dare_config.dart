import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';

part 'truth_or_dare_config.freezed.dart';

/// Per-game settings for a Truth or Dare match.
@freezed
abstract class TruthOrDareConfig with _$TruthOrDareConfig {
  const factory TruthOrDareConfig({
    /// Full rounds to play — every player gets one turn per round.
    @Default(3) int roundCount,
    @Default(TruthOrDareLevel.mild) TruthOrDareLevel level,

    /// Whether the host's own truths and dares join the bundled decks.
    @Default(true) bool includeCustomPrompts,
  }) = _TruthOrDareConfig;

  const TruthOrDareConfig._();

  static const minPlayers = 2;
  static const maxPlayers = 12;
  static const minRounds = 1;
  static const maxRounds = 10;
}
