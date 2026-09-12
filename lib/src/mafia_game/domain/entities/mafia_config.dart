import 'package:freezed_annotation/freezed_annotation.dart';

part 'mafia_config.freezed.dart';

/// Per-game settings for a Mafia match: how many mafia, which of the two
/// special town roles are in the deal, and the rule toggles.
@freezed
abstract class MafiaConfig with _$MafiaConfig {
  const factory MafiaConfig({
    @Default(1) int mafiaCount,

    /// Whether a doctor is dealt. Off makes for a faster, deadlier game.
    @Default(true) bool includeDoctor,

    /// Whether a detective is dealt.
    @Default(true) bool includeDetective,

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

  /// How many seats the chosen special roles take before villagers.
  int get specialCount => (includeDoctor ? 1 : 0) + (includeDetective ? 1 : 0);

  /// Largest balanced mafia count for [playerCount]: leaves room for the
  /// chosen specials and keeps the mafia a minority at the start.
  int maxMafiaFor(int playerCount) {
    final byBalance = (playerCount - 1) ~/ 2; // mafia < town at start
    final byRoster = playerCount - specialCount; // room for the specials
    final max = byBalance < byRoster ? byBalance : byRoster;
    return max < 1 ? 1 : max;
  }
}
