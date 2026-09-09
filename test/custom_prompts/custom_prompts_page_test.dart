import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';
import 'package:house_party_offline/src/custom_prompts/presentation/pages/custom_prompts_page.dart';
import 'package:house_party_offline/src/most_likely_to/domain/custom_prompt_deck.dart';

import '../helpers/fake_custom_prompts_repository.dart';

/// Exercises the real, wired-up [CustomPromptsPage]: the empty state, adding
/// from the field, and deleting.
void main() {
  late FakeCustomPromptsRepository repo;

  setUp(() {
    repo = FakeCustomPromptsRepository();
    getIt.registerSingleton<CustomPromptsRepository>(repo);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomPromptsPage(spec: kMostLikelyToPromptDeck),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('adding from the field lists and persists the prompt', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Nothing yet — add your first one below.'), findsOne);

    await tester.enterText(find.byType(TextField), 'Most likely to nap');
    await tester.tap(find.byTooltip('Add prompt'));
    await tester.pumpAndSettle();

    expect(find.text('Most likely to nap'), findsOneWidget);
    expect(find.text('Nothing yet — add your first one below.'), findsNothing);
    expect(
      repo.decks[kMostLikelyToPromptDeckId]?.single.text,
      'Most likely to nap',
    );
  });

  testWidgets('deleting removes the prompt', (tester) async {
    repo.decks[kMostLikelyToPromptDeckId] = const [
      CustomPrompt(id: 'p1', text: 'Most likely to nap'),
    ];
    await pump(tester);
    expect(find.text('Most likely to nap'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Most likely to nap'), findsNothing);
    expect(repo.decks[kMostLikelyToPromptDeckId], isEmpty);
  });
}
