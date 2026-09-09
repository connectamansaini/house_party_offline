import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/prompt_deck.dart';

/// Storage key for the host's own confessions — never rename once shipped.
const kNeverHaveIEverPromptDeckId = 'never_have_i_ever';

const kNeverHaveIEverPromptDeck = PromptDeckSpec(
  gameTitle: 'Never Have I Ever',
  gradient: AppColors.confessionGradient,
  sections: [
    PromptDeckSection(
      deckId: kNeverHaveIEverPromptDeckId,
      title: 'Confessions',
      hint: 'Never have I ever…',
    ),
  ],
);
