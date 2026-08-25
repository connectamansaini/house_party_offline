import 'package:equatable/equatable.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_session.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/night_resolution.dart';

/// States of the Mafia game FSM. Every state carries the [MafiaSession].
///
/// Hand-written (not freezed) — `MafiaNight`'s `copyWith` needs to explicitly
/// *clear* `selectedId`/`investigationReveal` back to null when advancing to
/// the next actor, which a generated `copyWith` can't express (it can't
/// distinguish "leave unset" from "set to null").
sealed class MafiaGameState extends Equatable {
  const MafiaGameState(this.session);

  final MafiaSession session;

  @override
  List<Object?> get props => [session];
}

/// Pass-and-play initial role reveal. Each player privately views their role
/// (mafia also see their teammates), then passes on.
class MafiaRoleReveal extends MafiaGameState {
  const MafiaRoleReveal(
    super.session, {
    required this.currentIndex,
    this.isRevealed = false,
  });

  final int currentIndex;
  final bool isRevealed;

  MafiaPlayer get currentPlayer => session.players[currentIndex];
  bool get isLastPlayer => currentIndex == session.players.length - 1;

  MafiaRoleReveal copyWith({int? currentIndex, bool? isRevealed}) {
    return MafiaRoleReveal(
      session,
      currentIndex: currentIndex ?? this.currentIndex,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  @override
  List<Object?> get props => [session, currentIndex, isRevealed];
}

/// Pass-and-play night. The phone goes to every living player; acting roles
/// secretly choose a target, villagers just pass.
class MafiaNight extends MafiaGameState {
  const MafiaNight(
    super.session, {
    required this.currentIndex,
    this.isRevealed = false,
    this.selectedId,
    this.investigationReveal,
    this.mafiaPicks = const {},
    this.doctorProtectId,
  });

  /// Index into [MafiaSession.livingPlayers].
  final int currentIndex;
  final bool isRevealed;

  /// Current actor's tentative pick.
  final String? selectedId;

  /// When a detective has confirmed, the result to show before passing on.
  final String? investigationReveal;

  /// Accumulated night actions.
  final Map<String, String> mafiaPicks;
  final String? doctorProtectId;

  MafiaPlayer get currentPlayer => session.livingPlayers[currentIndex];
  MafiaRole get currentRole => session.roleOf(currentPlayer.id);
  bool get isLastActor => currentIndex == session.livingPlayers.length - 1;

  MafiaNight copyWith({
    int? currentIndex,
    bool? isRevealed,
    String? selectedId,
    String? investigationReveal,
    Map<String, String>? mafiaPicks,
    String? doctorProtectId,
    bool clearSelection = false,
    bool clearInvestigation = false,
  }) {
    return MafiaNight(
      session,
      currentIndex: currentIndex ?? this.currentIndex,
      isRevealed: isRevealed ?? this.isRevealed,
      selectedId: clearSelection ? null : (selectedId ?? this.selectedId),
      investigationReveal: clearInvestigation
          ? null
          : (investigationReveal ?? this.investigationReveal),
      mafiaPicks: mafiaPicks ?? this.mafiaPicks,
      doctorProtectId: doctorProtectId ?? this.doctorProtectId,
    );
  }

  @override
  List<Object?> get props => [
    session,
    currentIndex,
    isRevealed,
    selectedId,
    investigationReveal,
    mafiaPicks,
    doctorProtectId,
  ];
}

/// Morning recap: what happened overnight. [winner] is set if the night ended
/// the game.
class MafiaNightRecap extends MafiaGameState {
  const MafiaNightRecap(super.session, {required this.resolution, this.winner});

  final NightResolution resolution;
  final MafiaFaction? winner;

  @override
  List<Object?> get props => [session, resolution, winner];
}

/// Daytime lynch vote — a shared selection with a skip option.
class MafiaDayVote extends MafiaGameState {
  const MafiaDayVote(super.session, {this.selectedId});

  final String? selectedId;

  MafiaDayVote copyWith({String? selectedId, bool clearSelection = false}) {
    return MafiaDayVote(
      session,
      selectedId: clearSelection ? null : (selectedId ?? this.selectedId),
    );
  }

  @override
  List<Object?> get props => [session, selectedId];
}

/// Result of the lynch vote. [lynchedId] is null when the day was skipped.
class MafiaLynchRecap extends MafiaGameState {
  const MafiaLynchRecap(super.session, {this.lynchedId, this.winner});

  final String? lynchedId;
  final MafiaFaction? winner;

  @override
  List<Object?> get props => [session, lynchedId, winner];
}

/// The match is over; [winner] took it.
class MafiaGameOver extends MafiaGameState {
  const MafiaGameOver(super.session, {required this.winner});

  final MafiaFaction winner;

  @override
  List<Object?> get props => [session, winner];
}
