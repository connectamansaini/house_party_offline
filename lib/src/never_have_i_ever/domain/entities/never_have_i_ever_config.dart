import 'package:freezed_annotation/freezed_annotation.dart';

part 'never_have_i_ever_config.freezed.dart';

/// Per-game settings for a Never Have I Ever match.
@freezed
abstract class NeverHaveIEverConfig with _$NeverHaveIEverConfig {
  const factory NeverHaveIEverConfig({
    /// How many prompts a player can match before they're out.
    @Default(3) int livesPerPlayer,
  }) = _NeverHaveIEverConfig;

  const NeverHaveIEverConfig._();

  static const minPlayers = 2;
  static const maxPlayers = 12;
  static const minLives = 1;
  static const maxLives = 10;
}
