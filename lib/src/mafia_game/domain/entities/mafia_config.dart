import 'package:freezed_annotation/freezed_annotation.dart';

part 'mafia_config.freezed.dart';

/// Per-game settings for a Mafia match. The role set is fixed in v1 (mafia +
/// one doctor + one detective + villagers); only the counts and rule toggles
/// vary.
@freezed
abstract class MafiaConfig with _$MafiaConfig {
  const factory MafiaConfig({
    @Default(1) int mafiaCount,

    /// Whether the mafia may kill on the very first night.
    @Default(true) bool firstNightKill,

    /// Whether the doctor may protect themselves.
    @Default(true) bool doctorSelfSave,

    /// Whether an investigation reveals the exact role vs. just mafia/not.
    @Default(true) bool detectiveExactRole,

    /// Whether a killed/lynched player's role is announced.
    @Default(true) bool revealRolesOnDeath,
  }) = _MafiaConfig;

  const MafiaConfig._();

  static const minPlayers = 5;
  static const maxPlayers = 15;

  /// Doctor + Detective always take two of the seats.
  static const reservedSpecials = 2;

  /// Largest balanced mafia count for [playerCount]: leaves room for the two
  /// specials and keeps the mafia a minority at the start.
  static int maxMafia(int playerCount) {
    final byBalance = (playerCount - 1) ~/ 2; // mafia < town at start
    final byRoster = playerCount - reservedSpecials; // room for specials
    final max = byBalance < byRoster ? byBalance : byRoster;
    return max < 1 ? 1 : max;
  }
}
