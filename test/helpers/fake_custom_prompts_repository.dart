import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';

/// In-memory stand-in for the custom prompt decks.
class FakeCustomPromptsRepository implements CustomPromptsRepository {
  FakeCustomPromptsRepository([Map<String, List<CustomPrompt>>? decks])
    : decks = {...?decks};

  final Map<String, List<CustomPrompt>> decks;

  @override
  Future<List<CustomPrompt>> load(String deckId) async =>
      decks[deckId] ?? const [];

  @override
  Future<void> save(String deckId, List<CustomPrompt> prompts) async =>
      decks[deckId] = prompts;
}
