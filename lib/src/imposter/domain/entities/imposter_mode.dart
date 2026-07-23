/// How much the imposter is told at role reveal.
enum ImposterMode {
  /// Word Imposter: the imposter gets no word (only an optional category hint)
  /// and must bluff purely from others' clues.
  blank,

  /// Undercover: the imposter is still told they are the imposter but also
  /// receives a different word from the same category to help them blend in.
  undercover;

  bool get isUndercover => this == ImposterMode.undercover;
}
