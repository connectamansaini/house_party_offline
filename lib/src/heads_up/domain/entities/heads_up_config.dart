import 'package:freezed_annotation/freezed_annotation.dart';

part 'heads_up_config.freezed.dart';

/// Per-game settings for a Heads Up match.
@freezed
abstract class HeadsUpConfig with _$HeadsUpConfig {
  const factory HeadsUpConfig({
    /// Seconds on the clock for each turn.
    @Default(60) int roundSeconds,

    /// Turns each player gets before the scores are final.
    @Default(1) int roundCount,
  }) = _HeadsUpConfig;

  const HeadsUpConfig._();

  static const minPlayers = 2;
  static const maxPlayers = 12;
  static const minRounds = 1;
  static const maxRounds = 5;
  static const secondsOptions = [30, 60, 90];

  /// Seconds of "get the phone on your forehead" before the clock starts.
  static const countdownSeconds = 3;
}
