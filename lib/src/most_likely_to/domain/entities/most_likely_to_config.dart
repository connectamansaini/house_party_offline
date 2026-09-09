import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';

part 'most_likely_to_config.freezed.dart';

/// Per-game settings for a Most Likely To match.
@freezed
abstract class MostLikelyToConfig with _$MostLikelyToConfig {
  const factory MostLikelyToConfig({
    /// How many prompts are played before the scores are final.
    @Default(10) int roundCount,

    /// Whether the host's own prompts join the bundled deck.
    @Default(true) bool includeCustomPrompts,

    /// Which bundled deck to deal from.
    @Default(PromptLanguage.english) PromptLanguage language,
  }) = _MostLikelyToConfig;

  const MostLikelyToConfig._();

  static const minPlayers = 3;
  static const maxPlayers = 12;
  static const minRounds = 3;
  static const maxRounds = 30;
}
