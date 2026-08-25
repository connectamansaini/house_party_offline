part of 'imposter_setup_bloc.dart';

sealed class ImposterSetupEvent extends Equatable {
  const ImposterSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Restores saved preferences (or seeds defaults), then loads packs.
class ImposterSetupStarted extends ImposterSetupEvent {
  const ImposterSetupStarted();
}

/// Retries loading the available word packs after a failure.
class ImposterSetupPacksRefreshRequested extends ImposterSetupEvent {
  const ImposterSetupPacksRefreshRequested();
}

class ImposterSetupPlayerAdded extends ImposterSetupEvent {
  const ImposterSetupPlayerAdded();
}

class ImposterSetupPlayerRemoved extends ImposterSetupEvent {
  const ImposterSetupPlayerRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class ImposterSetupPlayerRenamed extends ImposterSetupEvent {
  const ImposterSetupPlayerRenamed({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// Adds or removes a pack from the selection.
class ImposterSetupPackToggled extends ImposterSetupEvent {
  const ImposterSetupPackToggled(this.packId);

  final String packId;

  @override
  List<Object?> get props => [packId];
}

class ImposterSetupAllPacksSelected extends ImposterSetupEvent {
  const ImposterSetupAllPacksSelected();
}

class ImposterSetupPacksCleared extends ImposterSetupEvent {
  const ImposterSetupPacksCleared();
}

class ImposterSetupImposterCountChanged extends ImposterSetupEvent {
  const ImposterSetupImposterCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

class ImposterSetupImposterModeChanged extends ImposterSetupEvent {
  const ImposterSetupImposterModeChanged(this.mode);

  final ImposterMode mode;

  @override
  List<Object?> get props => [mode];
}

class ImposterSetupCategoryHintChanged extends ImposterSetupEvent {
  const ImposterSetupCategoryHintChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class ImposterSetupSecretVotingChanged extends ImposterSetupEvent {
  const ImposterSetupSecretVotingChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class ImposterSetupDiscussionMinutesChanged extends ImposterSetupEvent {
  const ImposterSetupDiscussionMinutesChanged(this.minutes);

  final int minutes;

  @override
  List<Object?> get props => [minutes];
}

class ImposterSetupCivilianWinPointsChanged extends ImposterSetupEvent {
  const ImposterSetupCivilianWinPointsChanged(this.points);

  final int points;

  @override
  List<Object?> get props => [points];
}

class ImposterSetupImposterWinPointsChanged extends ImposterSetupEvent {
  const ImposterSetupImposterWinPointsChanged(this.points);

  final int points;

  @override
  List<Object?> get props => [points];
}
