part of 'most_likely_to_setup_bloc.dart';

sealed class MostLikelyToSetupEvent extends Equatable {
  const MostLikelyToSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the shared roster into the form.
class MostLikelyToSetupStarted extends MostLikelyToSetupEvent {
  const MostLikelyToSetupStarted();
}

/// Saves the current names to the shared roster — sent when a game starts.
class MostLikelyToSetupRosterSaved extends MostLikelyToSetupEvent {
  const MostLikelyToSetupRosterSaved();
}

class MostLikelyToSetupPlayerAdded extends MostLikelyToSetupEvent {
  const MostLikelyToSetupPlayerAdded();
}

class MostLikelyToSetupPlayerRemoved extends MostLikelyToSetupEvent {
  const MostLikelyToSetupPlayerRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class MostLikelyToSetupPlayerRenamed extends MostLikelyToSetupEvent {
  const MostLikelyToSetupPlayerRenamed({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class MostLikelyToSetupRoundCountChanged extends MostLikelyToSetupEvent {
  const MostLikelyToSetupRoundCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}
