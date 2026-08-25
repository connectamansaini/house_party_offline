import 'package:equatable/equatable.dart';

/// Events driving the Mafia game state machine.
sealed class MafiaGameEvent extends Equatable {
  const MafiaGameEvent();

  @override
  List<Object?> get props => [];
}

/// Reveal phase: the current player taps to see their role.
class RoleRevealed extends MafiaGameEvent {
  const RoleRevealed();
}

/// Reveal phase: hide and pass to the next player (or start the first night).
class RolePassed extends MafiaGameEvent {
  const RolePassed();
}

/// Night: the current player takes the phone and opens their private screen.
class NightActorRevealed extends MafiaGameEvent {
  const NightActorRevealed();
}

/// Night: the current actor tentatively selects a target.
class NightTargetSelected extends MafiaGameEvent {
  const NightTargetSelected(this.playerId);

  final String playerId;

  @override
  List<Object?> get props => [playerId];
}

/// Night: confirm the current action and pass on. For the detective this shows
/// the investigation result first (acknowledge with [NightInvestigationSeen]).
/// Villagers confirm with nothing selected.
class NightActionConfirmed extends MafiaGameEvent {
  const NightActionConfirmed();
}

/// Night: the detective acknowledges the investigation result and passes on.
class NightInvestigationSeen extends MafiaGameEvent {
  const NightInvestigationSeen();
}

/// Day: tentatively select a lynch target.
class DayTargetSelected extends MafiaGameEvent {
  const DayTargetSelected(this.playerId);

  final String playerId;

  @override
  List<Object?> get props => [playerId];
}

/// Day: confirm the lynch of the selected player.
class DayVoteConfirmed extends MafiaGameEvent {
  const DayVoteConfirmed();
}

/// Day: skip the lynch — nobody is eliminated.
class DaySkipped extends MafiaGameEvent {
  const DaySkipped();
}

/// Advance past a recap (night result or lynch result) to the next phase.
class RecapContinued extends MafiaGameEvent {
  const RecapContinued();
}
