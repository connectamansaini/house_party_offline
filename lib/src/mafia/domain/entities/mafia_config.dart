import 'package:equatable/equatable.dart';

/// Per-game settings for a Mafia match. The role set is fixed in v1 (mafia +
/// one doctor + one detective + villagers); only the counts and rule toggles
/// vary.
class MafiaConfig extends Equatable {
  const MafiaConfig({
    this.mafiaCount = 1,
    this.firstNightKill = true,
    this.doctorSelfSave = true,
    this.detectiveExactRole = true,
    this.revealRolesOnDeath = true,
  });

  final int mafiaCount;

  /// Whether the mafia may kill on the very first night.
  final bool firstNightKill;

  /// Whether the doctor may protect themselves.
  final bool doctorSelfSave;

  /// Whether an investigation reveals the exact role vs. just mafia/not.
  final bool detectiveExactRole;

  /// Whether a killed/lynched player's role is announced.
  final bool revealRolesOnDeath;

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

  MafiaConfig copyWith({
    int? mafiaCount,
    bool? firstNightKill,
    bool? doctorSelfSave,
    bool? detectiveExactRole,
    bool? revealRolesOnDeath,
  }) {
    return MafiaConfig(
      mafiaCount: mafiaCount ?? this.mafiaCount,
      firstNightKill: firstNightKill ?? this.firstNightKill,
      doctorSelfSave: doctorSelfSave ?? this.doctorSelfSave,
      detectiveExactRole: detectiveExactRole ?? this.detectiveExactRole,
      revealRolesOnDeath: revealRolesOnDeath ?? this.revealRolesOnDeath,
    );
  }

  @override
  List<Object?> get props => [
    mafiaCount,
    firstNightKill,
    doctorSelfSave,
    detectiveExactRole,
    revealRolesOnDeath,
  ];
}
