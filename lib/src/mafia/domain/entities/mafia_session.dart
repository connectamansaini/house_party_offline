import 'package:equatable/equatable.dart';

import 'package:house_party_offline/src/mafia/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia/domain/entities/mafia_role.dart';

/// The evolving state of a Mafia match: the roster, dealt roles, who is still
/// alive, and the night counter.
class MafiaSession extends Equatable {
  const MafiaSession({
    required this.players,
    required this.roles,
    required this.aliveIds,
    required this.config,
    this.nightNumber = 1,
  });

  MafiaSession.initial({
    required this.players,
    required this.roles,
    required this.config,
  }) : aliveIds = players.map((p) => p.id).toSet(),
       nightNumber = 1;

  final List<MafiaPlayer> players;
  final Map<String, MafiaRole> roles;
  final Set<String> aliveIds;
  final MafiaConfig config;
  final int nightNumber;

  MafiaRole roleOf(String id) => roles[id]!;
  bool isAlive(String id) => aliveIds.contains(id);
  MafiaPlayer playerOf(String id) => players.firstWhere((p) => p.id == id);

  /// Living players in seating order (stable during a night).
  List<MafiaPlayer> get livingPlayers =>
      players.where((p) => aliveIds.contains(p.id)).toList();

  Set<String> get mafiaIds => {
    for (final e in roles.entries)
      if (e.value.isMafia) e.key,
  };

  /// Living mafia teammate names for [playerId] (excludes themselves).
  List<String> mafiaTeammateNames(String playerId) => [
    for (final p in players)
      if (p.id != playerId && roleOf(p.id).isMafia && isAlive(p.id)) p.name,
  ];

  MafiaSession copyWith({Set<String>? aliveIds, int? nightNumber}) {
    return MafiaSession(
      players: players,
      roles: roles,
      aliveIds: aliveIds ?? this.aliveIds,
      config: config,
      nightNumber: nightNumber ?? this.nightNumber,
    );
  }

  /// A copy with [id] removed from the living set.
  MafiaSession kill(String id) => copyWith(aliveIds: {...aliveIds}..remove(id));

  @override
  List<Object?> get props => [players, roles, aliveIds, config, nightNumber];
}
