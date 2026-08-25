part of 'mafia_setup_bloc.dart';

sealed class MafiaSetupEvent extends Equatable {
  const MafiaSetupEvent();

  @override
  List<Object?> get props => [];
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

class MafiaSetupMafiaCountChanged extends MafiaSetupEvent {
  const MafiaSetupMafiaCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
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
