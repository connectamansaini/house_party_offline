import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/core/utils/id.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/prompt_deck.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';

part 'custom_prompts_event.dart';
part 'custom_prompts_state.dart';

/// Edits every deck in one game's [PromptDeckSpec]. Each change is written
/// through immediately — there is no separate save step, so the host can't
/// lose a prompt by backing out.
class CustomPromptsBloc extends Bloc<CustomPromptsEvent, CustomPromptsState> {
  CustomPromptsBloc(this._repository, this.spec)
    : super(const CustomPromptsState()) {
    on<CustomPromptsStarted>(_onStarted);
    on<CustomPromptAdded>(_onAdded);
    on<CustomPromptEdited>(_onEdited);
    on<CustomPromptRemoved>(_onRemoved);
  }

  final CustomPromptsRepository _repository;
  final PromptDeckSpec spec;

  Future<void> _onStarted(
    CustomPromptsStarted event,
    Emitter<CustomPromptsState> emit,
  ) async {
    final decks = <String, List<CustomPrompt>>{};
    for (final section in spec.sections) {
      decks[section.deckId] = await _repository.load(section.deckId);
    }
    emit(CustomPromptsState(decks: decks, loaded: true));
  }

  Future<void> _onAdded(
    CustomPromptAdded event,
    Emitter<CustomPromptsState> emit,
  ) async {
    final text = event.text.trim();
    if (text.isEmpty) return;
    await _update(event.deckId, emit, (prompts) {
      return [...prompts, CustomPrompt(id: newId(), text: text)];
    });
  }

  Future<void> _onEdited(
    CustomPromptEdited event,
    Emitter<CustomPromptsState> emit,
  ) async {
    final text = event.text.trim();
    if (text.isEmpty) return;
    await _update(event.deckId, emit, (prompts) {
      return [
        for (final p in prompts)
          if (p.id == event.id) p.copyWith(text: text) else p,
      ];
    });
  }

  Future<void> _onRemoved(
    CustomPromptRemoved event,
    Emitter<CustomPromptsState> emit,
  ) async {
    await _update(event.deckId, emit, (prompts) {
      return prompts.where((p) => p.id != event.id).toList();
    });
  }

  Future<void> _update(
    String deckId,
    Emitter<CustomPromptsState> emit,
    List<CustomPrompt> Function(List<CustomPrompt> prompts) change,
  ) async {
    final updated = change(state.promptsFor(deckId));
    emit(state.copyWith(decks: {...state.decks, deckId: updated}));
    await _repository.save(deckId, updated);
  }
}
