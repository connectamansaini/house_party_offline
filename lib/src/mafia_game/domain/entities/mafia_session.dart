import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';

part 'mafia_session.freezed.dart';

/// The evolving state of a Mafia match: the roster, dealt roles, who is still
/// alive, and the night counter.
@freezed
abstract class MafiaSession with _$MafiaSession {
  const factory MafiaSession({
    required List<MafiaPlayer> players,
    required Map<String, MafiaRole> roles,
    required Set<String> aliveIds,
    required MafiaConfig config,
    @Default(1) int nightNumber,
  }) = _MafiaSession;

  const MafiaSession._();

  /// A freshly dealt match: everyone starts alive, on night 1.
  ///
  /// A static factory-style method rather than a named constructor: it
  /// derives `aliveIds` from `players` rather than redirecting, and a
  /// freezed union expects every declared factory constructor to be one of
  /// its variants.
  // ignore: prefer_constructors_over_static_methods
  static MafiaSession initial({
    required List<MafiaPlayer> players,
    required Map<String, MafiaRole> roles,
    required MafiaConfig config,
  }) {
    return MafiaSession(
      players: players,
      roles: roles,
      aliveIds: players.map((p) => p.id).toSet(),
      config: config,
    );
  }

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

  /// A copy with [id] removed from the living set.
  MafiaSession kill(String id) => copyWith(aliveIds: {...aliveIds}..remove(id));
}
