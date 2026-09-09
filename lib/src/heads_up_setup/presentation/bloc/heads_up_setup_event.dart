part of 'heads_up_setup_bloc.dart';

sealed class HeadsUpSetupEvent extends Equatable {
  const HeadsUpSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the shared roster and the word packs.
class HeadsUpSetupStarted extends HeadsUpSetupEvent {
  const HeadsUpSetupStarted();
}

/// Saves the current names to the shared roster — sent when a game starts.
class HeadsUpSetupRosterSaved extends HeadsUpSetupEvent {
  const HeadsUpSetupRosterSaved();
}

class HeadsUpSetupPlayerAdded extends HeadsUpSetupEvent {
  const HeadsUpSetupPlayerAdded();
}

class HeadsUpSetupPlayerRemoved extends HeadsUpSetupEvent {
  const HeadsUpSetupPlayerRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class HeadsUpSetupPlayerRenamed extends HeadsUpSetupEvent {
  const HeadsUpSetupPlayerRenamed({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class HeadsUpSetupPackToggled extends HeadsUpSetupEvent {
  const HeadsUpSetupPackToggled(this.packId);

  final String packId;

  @override
  List<Object?> get props => [packId];
}

class HeadsUpSetupRoundSecondsChanged extends HeadsUpSetupEvent {
  const HeadsUpSetupRoundSecondsChanged(this.seconds);

  final int seconds;

  @override
  List<Object?> get props => [seconds];
}

class HeadsUpSetupRoundCountChanged extends HeadsUpSetupEvent {
  const HeadsUpSetupRoundCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}
