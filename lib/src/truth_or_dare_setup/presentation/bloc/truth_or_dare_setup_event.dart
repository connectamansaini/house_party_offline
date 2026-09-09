part of 'truth_or_dare_setup_bloc.dart';

sealed class TruthOrDareSetupEvent extends Equatable {
  const TruthOrDareSetupEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the shared roster into the form.
class TruthOrDareSetupStarted extends TruthOrDareSetupEvent {
  const TruthOrDareSetupStarted();
}

/// Saves the current names to the shared roster — sent when a game starts.
class TruthOrDareSetupRosterSaved extends TruthOrDareSetupEvent {
  const TruthOrDareSetupRosterSaved();
}

class TruthOrDareSetupIncludeCustomPromptsChanged
    extends TruthOrDareSetupEvent {
  const TruthOrDareSetupIncludeCustomPromptsChanged({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

class TruthOrDareSetupPlayerAdded extends TruthOrDareSetupEvent {
  const TruthOrDareSetupPlayerAdded();
}

class TruthOrDareSetupPlayerRemoved extends TruthOrDareSetupEvent {
  const TruthOrDareSetupPlayerRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class TruthOrDareSetupPlayerRenamed extends TruthOrDareSetupEvent {
  const TruthOrDareSetupPlayerRenamed({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class TruthOrDareSetupRoundCountChanged extends TruthOrDareSetupEvent {
  const TruthOrDareSetupRoundCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

class TruthOrDareSetupLevelChanged extends TruthOrDareSetupEvent {
  const TruthOrDareSetupLevelChanged(this.level);

  final TruthOrDareLevel level;

  @override
  List<Object?> get props => [level];
}
