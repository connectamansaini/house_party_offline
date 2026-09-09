import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/prompt_deck.dart';

/// Storage keys for the host's own truths and dares — never rename once
/// shipped.
const kTruthOrDareTruthDeckId = 'truth_or_dare_truths';
const kTruthOrDareDareDeckId = 'truth_or_dare_dares';

const kTruthOrDarePromptDeck = PromptDeckSpec(
  gameTitle: 'Truth or Dare',
  gradient: AppColors.dareGradient,
  sections: [
    PromptDeckSection(
      deckId: kTruthOrDareTruthDeckId,
      title: 'Truths',
      hint: 'A question they have to answer honestly',
    ),
    PromptDeckSection(
      deckId: kTruthOrDareDareDeckId,
      title: 'Dares',
      hint: 'Something they have to do right now',
    ),
  ],
);
