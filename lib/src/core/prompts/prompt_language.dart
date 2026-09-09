/// Which bundled deck a prompt game deals from. The host's own prompts are
/// added on top regardless of the pick.
enum PromptLanguage {
  english,

  /// Hindi in Roman script with English mixed in, the way most of the
  /// intended rooms actually talk.
  hinglish;

  String get label => switch (this) {
    PromptLanguage.english => 'English',
    PromptLanguage.hinglish => 'Hinglish',
  };
}
