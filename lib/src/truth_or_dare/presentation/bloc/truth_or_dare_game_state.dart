part of 'truth_or_dare_game_bloc.dart';

class TruthOrDareGameState extends Equatable {
  const TruthOrDareGameState({required this.session, this.kind, this.prompt});

  final TruthOrDareSession session;

  /// What the current player chose, once they have; null while choosing.
  final TruthOrDareKind? kind;

  /// The drawn prompt for this turn; null while the player is still choosing.
  final String? prompt;

  bool get isChoosing => prompt == null;

  @override
  List<Object?> get props => [session, kind, prompt];
}
