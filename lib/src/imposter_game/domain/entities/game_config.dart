import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/imposter_mode.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/word_pack.dart';

part 'game_config.freezed.dart';

/// Per-game settings chosen by the host during setup. Immutable once a game
/// starts.
@freezed
abstract class GameConfig with _$GameConfig {
  const factory GameConfig({
    /// The word packs rounds draw their secret word from. When more than one
    /// is selected, the word is chosen across all of them and the category
    /// hint (if enabled) reflects the chosen word's own pack.
    required List<WordPack> packs,

    /// How many imposters are dealt in each round. Must satisfy
    /// `1 <= imposterCount < playerCount`.
    @Default(1) int imposterCount,

    /// What the imposter receives at reveal (nothing vs. a decoy word).
    @Default(ImposterMode.blank) ImposterMode imposterMode,

    /// When true, imposters are told the chosen word's category as a hint.
    @Default(false) bool categoryHintEnabled,

    /// When true, voting is a pass-and-play secret ballot (each player casts
    /// privately, then the votes are tallied). When false, the group casts
    /// one shared vote on the device.
    @Default(false) bool secretVoting,
    @Default(Duration(minutes: 3)) Duration discussionTime,

    /// Points awarded to each member of the winning side.
    @Default(1) int civilianWinPoints,
    @Default(2) int imposterWinPoints,
  }) = _GameConfig;

  const GameConfig._();

  /// Largest imposter count that still leaves at least one civilian member.
  static int maxImposters(int playerCount) =>
      playerCount <= 1 ? 0 : playerCount - 1;
}
