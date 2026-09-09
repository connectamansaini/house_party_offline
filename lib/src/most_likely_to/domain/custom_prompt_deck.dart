import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/prompt_deck.dart';

/// Storage key for the host's own prompts — never rename once shipped.
const kMostLikelyToPromptDeckId = 'most_likely_to';

const kMostLikelyToPromptDeck = PromptDeckSpec(
  gameTitle: 'Most Likely To',
  gradient: AppColors.spotlightGradient,
  sections: [
    PromptDeckSection(
      deckId: kMostLikelyToPromptDeckId,
      title: 'Prompts',
      hint: 'Most likely to…',
    ),
  ],
);
