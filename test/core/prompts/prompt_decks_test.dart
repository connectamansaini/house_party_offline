import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/most_likely_to/domain/prompts.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/prompts.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_level.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/prompts.dart';

/// A deck is worth shipping if it's big enough for a match, has no
/// duplicates, and no blank or untrimmed entries.
void expectDeck(List<String> deck, {int atLeast = 10}) {
  expect(deck.length, greaterThanOrEqualTo(atLeast));
  expect(deck.toSet().length, deck.length, reason: 'duplicate prompt');
  for (final prompt in deck) {
    expect(prompt.trim(), prompt, reason: 'untrimmed: "$prompt"');
    expect(prompt, isNotEmpty);
  }
}

void main() {
  group('Never Have I Ever', () {
    for (final language in PromptLanguage.values) {
      test('${language.label} deck is playable', () {
        expectDeck(neverHaveIEverPromptsFor(language), atLeast: 25);
      });
    }

    test('the two decks do not overlap', () {
      final english = neverHaveIEverPromptsFor(PromptLanguage.english).toSet();
      final hinglish = neverHaveIEverPromptsFor(
        PromptLanguage.hinglish,
      ).toSet();
      expect(english.intersection(hinglish), isEmpty);
    });
  });

  group('Most Likely To', () {
    for (final language in PromptLanguage.values) {
      test('${language.label} deck is playable', () {
        expectDeck(mostLikelyToPromptsFor(language), atLeast: 25);
      });
    }

    test('the two decks do not overlap', () {
      final english = mostLikelyToPromptsFor(PromptLanguage.english).toSet();
      final hinglish = mostLikelyToPromptsFor(PromptLanguage.hinglish).toSet();
      expect(english.intersection(hinglish), isEmpty);
    });
  });

  group('Truth or Dare', () {
    for (final language in PromptLanguage.values) {
      for (final level in TruthOrDareLevel.values) {
        test('${language.label} ${level.label} decks are playable', () {
          expectDeck(truthsFor(level, language));
          expectDeck(daresFor(level, language));
        });
      }

      test('${language.label} spicy contains mild and adds more', () {
        final mild = truthsFor(TruthOrDareLevel.mild, language);
        final spicy = truthsFor(TruthOrDareLevel.spicy, language);
        expect(spicy, containsAll(mild));
        expect(spicy.length, greaterThan(mild.length));
      });
    }

    test('the language defaults to English', () {
      expect(truthsFor(TruthOrDareLevel.mild), kMildTruths);
      expect(daresFor(TruthOrDareLevel.mild), kMildDares);
    });
  });
}
