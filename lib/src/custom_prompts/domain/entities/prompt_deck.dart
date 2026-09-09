import 'package:flutter/painting.dart';

/// One editable list of prompts. A game's spec has one section (Never Have
/// I Ever, Most Likely To) or several (Truth or Dare: truths and dares).
class PromptDeckSection {
  const PromptDeckSection({
    required this.deckId,
    required this.title,
    required this.hint,
  });

  /// Stable storage key — never rename once shipped.
  final String deckId;
  final String title;

  /// Shown as the add field's placeholder, e.g. `Never have I ever...`.
  final String hint;
}

/// Everything the shared editor needs to present one game's custom decks.
class PromptDeckSpec {
  const PromptDeckSpec({
    required this.gameTitle,
    required this.gradient,
    required this.sections,
  });

  final String gameTitle;

  /// Only its first stop is used, as the accent.
  final Gradient gradient;
  final List<PromptDeckSection> sections;
}
