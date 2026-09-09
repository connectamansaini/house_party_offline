import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';

/// Host-written prompts, one list per deck id, in the order they were added.
abstract interface class CustomPromptsRepository {
  Future<List<CustomPrompt>> load(String deckId);

  Future<void> save(String deckId, List<CustomPrompt> prompts);
}
