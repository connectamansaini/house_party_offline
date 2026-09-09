/// How cheeky the prompt deck is. Spicy is a superset of mild.
enum TruthOrDareLevel {
  mild,
  spicy;

  String get label => switch (this) {
    TruthOrDareLevel.mild => 'Mild',
    TruthOrDareLevel.spicy => 'Spicy',
  };
}
