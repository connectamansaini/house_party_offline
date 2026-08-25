import 'dart:math';

import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/night_resolution.dart';

/// Pure game rules for Mafia. No Flutter/BLoC/IO so the full night/day
/// lifecycle is unit-testable. Randomness is injected via [Random].
class MafiaEngine {
  const MafiaEngine();

  /// Deals roles: [MafiaConfig.mafiaCount] mafia, one doctor, one detective,
  /// and the rest villagers. Throws [ArgumentError] on an invalid roster.
  Map<String, MafiaRole> assignRoles(
    List<MafiaPlayer> players,
    MafiaConfig config, {
    Random? rng,
  }) {
    if (players.length < MafiaConfig.reservedSpecials + 1) {
      throw ArgumentError(
        'Need at least 3 players (mafia, doctor, detective).',
      );
    }
    final ids = players.map((p) => p.id).toSet();
    if (ids.length != players.length) {
      throw ArgumentError('Player ids must be unique.');
    }
    if (config.mafiaCount < 1 ||
        config.mafiaCount > players.length - MafiaConfig.reservedSpecials) {
      throw ArgumentError(
        'mafiaCount must leave room for a doctor and a detective '
        '(count=${config.mafiaCount}, players=${players.length}).',
      );
    }

    final shuffled = List<MafiaPlayer>.of(players)..shuffle(rng ?? Random());
    final roles = <String, MafiaRole>{};
    var i = 0;
    for (; i < config.mafiaCount; i++) {
      roles[shuffled[i].id] = MafiaRole.mafia;
    }
    roles[shuffled[i++].id] = MafiaRole.doctor;
    roles[shuffled[i++].id] = MafiaRole.detective;
    for (; i < shuffled.length; i++) {
      roles[shuffled[i].id] = MafiaRole.villager;
    }
    return roles;
  }

  /// Resolves the mafia's collective kill from each mafia member's pick: the
  /// target with the most votes, ties broken at random. Null if no picks.
  String? resolveMafiaKill(Map<String, String> picks, {Random? rng}) {
    if (picks.isEmpty) return null;
    final counts = <String, int>{};
    for (final target in picks.values) {
      counts[target] = (counts[target] ?? 0) + 1;
    }
    final max = counts.values.reduce((a, b) => a > b ? a : b);
    final leaders = [
      for (final e in counts.entries)
        if (e.value == max) e.key,
    ]..sort();
    if (leaders.length == 1) return leaders.first;
    return leaders[(rng ?? Random()).nextInt(leaders.length)];
  }

  /// Applies the doctor's protection to the mafia's target for a night.
  ///
  /// On the first night, a kill only happens when [MafiaConfig.firstNightKill]
  /// is true.
  NightResolution resolveNight({
    required String? killTarget,
    required String? doctorProtect,
    required bool isFirstNight,
    required MafiaConfig config,
  }) {
    if (killTarget == null || (isFirstNight && !config.firstNightKill)) {
      return const NightResolution();
    }
    if (killTarget == doctorProtect) {
      return NightResolution(savedId: killTarget);
    }
    return NightResolution(killedId: killTarget);
  }

  /// What the detective learns about [role].
  String investigationResult(MafiaRole role, MafiaConfig config) {
    if (config.detectiveExactRole) return role.label;
    return role.isMafia ? 'Mafia' : 'Not Mafia';
  }

  /// The winning faction given who is alive, or null if the game continues.
  /// Town wins when no mafia remain; mafia win once they reach parity.
  MafiaFaction? winner(
    Map<String, MafiaRole> roles,
    Set<String> aliveIds,
  ) {
    var mafiaAlive = 0;
    var townAlive = 0;
    for (final id in aliveIds) {
      final role = roles[id];
      if (role == null) continue;
      if (role.isMafia) {
        mafiaAlive++;
      } else {
        townAlive++;
      }
    }
    if (mafiaAlive == 0) return MafiaFaction.town;
    if (mafiaAlive >= townAlive) return MafiaFaction.mafia;
    return null;
  }
}
