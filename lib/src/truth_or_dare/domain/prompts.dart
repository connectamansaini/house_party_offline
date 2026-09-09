import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/prompts_hinglish.dart';

/// Bundled prompts, kept as plain Dart like the other prompt games — v1 has
/// no pack selection beyond the spice level. Dares are all doable in a
/// living room with nothing but the people in it.
List<String> truthsFor(
  TruthOrDareLevel level, [
  PromptLanguage language = PromptLanguage.english,
]) {
  final (mild, spicy) = switch (language) {
    PromptLanguage.english => (kMildTruths, kSpicyTruths),
    PromptLanguage.hinglish => (kMildTruthsHinglish, kSpicyTruthsHinglish),
  };
  return switch (level) {
    TruthOrDareLevel.mild => mild,
    TruthOrDareLevel.spicy => [...mild, ...spicy],
  };
}

List<String> daresFor(
  TruthOrDareLevel level, [
  PromptLanguage language = PromptLanguage.english,
]) {
  final (mild, spicy) = switch (language) {
    PromptLanguage.english => (kMildDares, kSpicyDares),
    PromptLanguage.hinglish => (kMildDaresHinglish, kSpicyDaresHinglish),
  };
  return switch (level) {
    TruthOrDareLevel.mild => mild,
    TruthOrDareLevel.spicy => [...mild, ...spicy],
  };
}

const kMildTruths = <String>[
  "What's the most embarrassing thing on your phone right now?",
  "What's a lie you told this week?",
  'Who in this room would you call first in an emergency?',
  "What's the strangest thing you've ever eaten?",
  "What's your most irrational fear?",
  "What's the last thing you searched for online?",
  "What's a habit you'd be embarrassed for people to know about?",
  "What's the longest you've gone without showering?",
  'Have you ever pretended to like a gift? What was it?',
  "What's the worst haircut you've ever had?",
  "What's a movie you cried at that you'd never admit to?",
  'What was your most awkward date?',
  "What's the pettiest thing you've ever done?",
  "What's something you still can't do that most adults can?",
  "Who's the last person you stalked online?",
  "What's the most childish thing you still do?",
  'What song do you secretly love?',
  "What's the worst thing you've said to a teacher or a boss?",
  'Have you ever blamed someone else for something you did?',
  "What's the dumbest way you've hurt yourself?",
  "What's one thing you've never told your parents?",
  "What's your guilty-pleasure TV show?",
  'Which person here do you think is the best cook?',
  "What's the longest you've kept a secret?",
  'Have you ever re-gifted something? To whom?',
  "What's the weirdest dream you remember?",
  'When did you last cry, and why?',
  "What's the most money you've wasted on something useless?",
  'Which app do you spend way too much time on?',
  "What's a nickname you've had that you hated?",
];

const kMildDares = <String>[
  'Do your best impression of someone in this room.',
  'Talk in an accent until your next turn.',
  'Let the group pick a song — sing the chorus.',
  'Do ten push-ups right now.',
  'Speak only in questions until your next turn.',
  'Show the group the last photo you took.',
  'Dance with no music for thirty seconds.',
  'Let the person on your left post a comment from your phone.',
  'Say the alphabet backwards. Fail and go again.',
  'Do your best runway walk across the room.',
  'Hold a plank while the group counts to twenty.',
  'Let the group give you a new hairstyle with whatever is around.',
  'Compliment every person in the room, sincerely.',
  'Act out a movie scene until someone guesses it.',
  'Balance a spoon on your nose for ten seconds.',
  "Speak in a whisper until it's your turn again.",
  'Do a dramatic reading of your most recent text message.',
  'Invent a handshake with the person on your right.',
  'Pretend to be a news anchor and report on this party.',
  "Eat a spoonful of a condiment of the group's choice.",
  'Let someone draw on your hand with a pen.',
  'Do twenty jumping jacks while singing.',
  'Call a friend and sing them Happy Birthday.',
  'Wear your socks on your hands until your next turn.',
  'Do your best animal impression until someone guesses it.',
  'Freestyle a rap about the person opposite you.',
  'Stand on one leg for the rest of the round.',
  'Say something nice about the last person you argued with.',
  'Let the group choose your profile picture for a day.',
  'Do a slow-motion replay of your entrance to this party.',
];

const kSpicyTruths = <String>[
  'Who in this room would you swap lives with for a day, and why?',
  "What's the most embarrassing thing you've done to impress a crush?",
  'Who was your first kiss, and how did it go?',
  "What's a secret you've never told anyone in this room?",
  "What's the cheesiest pickup line you've actually used?",
  'Have you ever ghosted someone here? Who?',
  "What's the biggest lie you've told on a date?",
  'Which person in this room has the best style?',
  "What was the most awkward moment with a partner's family?",
  "What's the worst thing you've done while drunk?",
  'Who in this room would you least want to be stuck in a lift with?',
  "What's a text you regret sending?",
  "Have you ever had a crush on a friend's partner?",
  "What's the most romantic thing you've done — and did it work?",
  'Who in this room do you think secretly likes you?',
];

const kSpicyDares = <String>[
  'Let the group read your most recent chat out loud.',
  'Send a heart emoji to the third contact in your phone.',
  'Give the person on your left a thirty-second massage.',
  'Serenade the person opposite you.',
  'Let the group go through your photo gallery for one minute.',
  'Do a slow dance with the person the group picks.',
  'Text your ex "thinking of you" — or take the point loss.',
  'Whisper something flattering into the ear of the person on your right.',
  'Let someone else write your next social media post.',
  "Sit on someone's lap until your next turn.",
  'Show the group your screen time report.',
  'Swap an item of clothing with the person the group chooses.',
  'Do your sexiest walk across the room.',
  'Let the group send one message from your phone to anyone.',
  'Give a toast to the person you find most attractive here.',
];
