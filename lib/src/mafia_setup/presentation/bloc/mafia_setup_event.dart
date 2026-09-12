part of 'mafia_setup_bloc.dart';

sealed class MafiaSetupEvent extends Equatable {
  const MafiaSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the shared roster into the form.
class MafiaSetupStarted extends MafiaSetupEvent {
  const MafiaSetupStarted();
}

/// Saves the current names to the shared roster — sent when a game starts.
class MafiaSetupRosterSaved extends MafiaSetupEvent {
  const MafiaSetupRosterSaved();
}

class MafiaSetupPlayerAdded extends MafiaSetupEvent {
  const MafiaSetupPlayerAdded();
}

class MafiaSetupPlayerRemoved extends MafiaSetupEvent {
  const MafiaSetupPlayerRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class MafiaSetupPlayerRenamed extends MafiaSetupEvent {
  const MafiaSetupPlayerRenamed({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// Turns narrator mode on (defaulting to the first player) or off.
class MafiaSetupHostModeChanged extends MafiaSetupEvent {
  const MafiaSetupHostModeChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

/// Hands the job to the next person each game, or keeps it with one.
class MafiaSetupRotateHostChanged extends MafiaSetupEvent {
  const MafiaSetupRotateHostChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

/// Picks which roster entry narrates.
class MafiaSetupHostChanged extends MafiaSetupEvent {
  const MafiaSetupHostChanged(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class MafiaSetupMafiaCountChanged extends MafiaSetupEvent {
  const MafiaSetupMafiaCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

/// Deals a doctor, or leaves the town without one.
class MafiaSetupIncludeDoctorChanged extends MafiaSetupEvent {
  const MafiaSetupIncludeDoctorChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

/// Deals a detective, or leaves the town without one.
class MafiaSetupIncludeDetectiveChanged extends MafiaSetupEvent {
  const MafiaSetupIncludeDetectiveChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class MafiaSetupRevealRolesOnDeathChanged extends MafiaSetupEvent {
  const MafiaSetupRevealRolesOnDeathChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class MafiaSetupFirstNightKillChanged extends MafiaSetupEvent {
  const MafiaSetupFirstNightKillChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class MafiaSetupDoctorSelfSaveChanged extends MafiaSetupEvent {
  const MafiaSetupDoctorSelfSaveChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class MafiaSetupDetectiveExactRoleChanged extends MafiaSetupEvent {
  const MafiaSetupDetectiveExactRoleChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
