/// What a player chose to face on their turn.
enum TruthOrDareKind {
  truth,
  dare;

  String get label => switch (this) {
    TruthOrDareKind.truth => 'Truth',
    TruthOrDareKind.dare => 'Dare',
  };
}
