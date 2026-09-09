part of 'truth_or_dare_game_bloc.dart';

sealed class TruthOrDareGameEvent extends Equatable {
  const TruthOrDareGameEvent();

  @override
  List<Object?> get props => [];
}

/// The current player picked truth or dare; a prompt is drawn.
class TruthOrDareKindChosen extends TruthOrDareGameEvent {
  const TruthOrDareKindChosen(this.kind);

  final TruthOrDareKind kind;

  @override
  List<Object?> get props => [kind];
}

/// The current player either went through with the prompt or skipped it.
class TruthOrDareTurnResolved extends TruthOrDareGameEvent {
  const TruthOrDareTurnResolved({required this.done});

  final bool done;

  @override
  List<Object?> get props => [done];
}
