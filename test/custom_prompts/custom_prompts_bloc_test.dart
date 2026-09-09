import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/custom_prompts/presentation/bloc/custom_prompts_bloc.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/custom_prompt_deck.dart';

import '../helpers/fake_custom_prompts_repository.dart';

Future<CustomPromptsState> _emitUntil(
  CustomPromptsBloc bloc,
  CustomPromptsEvent event,
  bool Function(CustomPromptsState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  test('Started loads every deck in the spec', () async {
    final repo = FakeCustomPromptsRepository({
      kTruthOrDareTruthDeckId: const [CustomPrompt(id: 't1', text: 'A truth')],
    });
    final bloc = CustomPromptsBloc(repo, kTruthOrDarePromptDeck);

    final s = await _emitUntil(
      bloc,
      const CustomPromptsStarted(),
      (s) => s.loaded,
    );

    expect(s.promptsFor(kTruthOrDareTruthDeckId).single.text, 'A truth');
    expect(s.promptsFor(kTruthOrDareDareDeckId), isEmpty);
    expect(s.total, 1);
    await bloc.close();
  });

  test('add, edit and remove write through to the right deck', () async {
    final repo = FakeCustomPromptsRepository();
    final bloc = CustomPromptsBloc(repo, kTruthOrDarePromptDeck);

    var s = await _emitUntil(
      bloc,
      const CustomPromptAdded(deckId: kTruthOrDareDareDeckId, text: '  Sing  '),
      (s) => s.total == 1,
    );
    final added = s.promptsFor(kTruthOrDareDareDeckId).single;
    expect(added.text, 'Sing');
    expect(repo.decks[kTruthOrDareDareDeckId]?.single.text, 'Sing');

    s = await _emitUntil(
      bloc,
      CustomPromptEdited(
        deckId: kTruthOrDareDareDeckId,
        id: added.id,
        text: 'Sing loudly',
      ),
      (s) => s.promptsFor(kTruthOrDareDareDeckId).single.text == 'Sing loudly',
    );
    expect(repo.decks[kTruthOrDareDareDeckId]?.single.text, 'Sing loudly');

    s = await _emitUntil(
      bloc,
      CustomPromptRemoved(deckId: kTruthOrDareDareDeckId, id: added.id),
      (s) => s.total == 0,
    );
    expect(repo.decks[kTruthOrDareDareDeckId], isEmpty);
    expect(s.promptsFor(kTruthOrDareTruthDeckId), isEmpty);
    await bloc.close();
  });

  test('blank text is ignored', () async {
    final repo = FakeCustomPromptsRepository();
    final bloc = CustomPromptsBloc(
      repo,
      kTruthOrDarePromptDeck,
    )..add(const CustomPromptAdded(deckId: kTruthOrDareTruthDeckId, text: ' '));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.total, 0);
    expect(repo.decks, isEmpty);
    await bloc.close();
  });
}
