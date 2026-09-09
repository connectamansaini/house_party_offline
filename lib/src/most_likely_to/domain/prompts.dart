import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/most_likely_to/domain/prompts_hinglish.dart';

/// The bundled deck for [language].
List<String> mostLikelyToPromptsFor(PromptLanguage language) =>
    switch (language) {
      PromptLanguage.english => kMostLikelyToPrompts,
      PromptLanguage.hinglish => kMostLikelyToPromptsHinglish,
    };

/// Bundled "Most likely to..." prompts. Kept as plain Dart (not an asset
/// pack) for the same reason as Never Have I Ever — the only pick is the
/// language, so the asset-loading machinery would be unused complexity.
const kMostLikelyToPrompts = <String>[
  'Most likely to become famous.',
  'Most likely to forget their own birthday.',
  'Most likely to survive a zombie apocalypse.',
  'Most likely to cry at a wedding.',
  'Most likely to get lost with a map in their hands.',
  'Most likely to win the lottery and lose the ticket.',
  'Most likely to talk their way out of a speeding ticket.',
  'Most likely to fall asleep at a party.',
  'Most likely to start a business on a whim.',
  'Most likely to adopt five dogs.',
  'Most likely to become a millionaire.',
  'Most likely to move to another country.',
  'Most likely to laugh at their own joke before finishing it.',
  'Most likely to text back three days later.',
  'Most likely to eat dessert before dinner.',
  'Most likely to end up on a reality TV show.',
  'Most likely to spend all their money on food.',
  'Most likely to lose their phone on a night out.',
  'Most likely to break a world record.',
  'Most likely to still be dancing when the music stops.',
  'Most likely to set off the smoke alarm while cooking.',
  'Most likely to go viral by accident.',
  'Most likely to befriend a stranger on a train.',
  'Most likely to plan the whole trip and then miss the flight.',
  'Most likely to become a teacher.',
  'Most likely to argue with a GPS.',
  'Most likely to write a book one day.',
  'Most likely to be late to their own wedding.',
  'Most likely to binge a whole series in one night.',
  'Most likely to run a marathon on a dare.',
  'Most likely to spoil the ending of a movie.',
  'Most likely to become a politician.',
  'Most likely to sing karaoke completely sober.',
  'Most likely to keep a secret forever.',
  'Most likely to spill a secret within an hour.',
  'Most likely to get a tattoo they regret.',
  'Most likely to be secretly rich.',
  'Most likely to live to a hundred.',
  'Most likely to trip over nothing.',
  'Most likely to talk to their pets like people.',
  'Most likely to quit their job to travel the world.',
  'Most likely to be caught dancing alone.',
  'Most likely to order for the whole table.',
  'Most likely to cry over a fictional character.',
  'Most likely to become an astronaut.',
  'Most likely to win an argument with pure confidence.',
  'Most likely to have a secret talent nobody knows about.',
  'Most likely to send a voice note instead of typing.',
  'Most likely to be the last one awake at a sleepover.',
  'Most likely to make friends with the bartender.',
  'Most likely to forget where they parked.',
  'Most likely to start a food fight.',
];
