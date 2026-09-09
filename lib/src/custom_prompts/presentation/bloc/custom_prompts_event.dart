part of 'custom_prompts_bloc.dart';

sealed class CustomPromptsEvent extends Equatable {
  const CustomPromptsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads every deck in the spec.
class CustomPromptsStarted extends CustomPromptsEvent {
  const CustomPromptsStarted();
}

class CustomPromptAdded extends CustomPromptsEvent {
  const CustomPromptAdded({required this.deckId, required this.text});

  final String deckId;
  final String text;

  @override
  List<Object?> get props => [deckId, text];
}

class CustomPromptEdited extends CustomPromptsEvent {
  const CustomPromptEdited({
    required this.deckId,
    required this.id,
    required this.text,
  });

  final String deckId;
  final String id;
  final String text;

  @override
  List<Object?> get props => [deckId, id, text];
}

class CustomPromptRemoved extends CustomPromptsEvent {
  const CustomPromptRemoved({required this.deckId, required this.id});

  final String deckId;
  final String id;

  @override
  List<Object?> get props => [deckId, id];
}
