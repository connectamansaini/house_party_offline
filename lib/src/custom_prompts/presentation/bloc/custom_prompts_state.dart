part of 'custom_prompts_bloc.dart';

class CustomPromptsState extends Equatable {
  const CustomPromptsState({this.decks = const {}, this.loaded = false});

  /// Prompts per deck id, in the order the host added them.
  final Map<String, List<CustomPrompt>> decks;

  /// False until every deck has been read, so the empty state doesn't flash.
  final bool loaded;

  List<CustomPrompt> promptsFor(String deckId) => decks[deckId] ?? const [];

  int get total => decks.values.fold(0, (sum, d) => sum + d.length);

  CustomPromptsState copyWith({
    Map<String, List<CustomPrompt>>? decks,
    bool? loaded,
  }) {
    return CustomPromptsState(
      decks: decks ?? this.decks,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [decks, loaded];
}
