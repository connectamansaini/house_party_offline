import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever_setup/presentation/pages/never_have_i_ever_setup_page.dart';

/// Exercises the real, wired-up [NeverHaveIEverSetupPage] end to end — the
/// roster list, the options, and the Start button.
void main() {
  testWidgets(
    'renders the default roster and options, with Start game enabled',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: NeverHaveIEverSetupPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Players'), findsOneWidget);
      expect(
        find.byType(TextField),
        findsNWidgets(NeverHaveIEverConfig.minPlayers),
      );
      expect(find.text('Options'), findsOneWidget);
      expect(find.text('Lives per player'), findsOneWidget);

      final startButton = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Start game'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(startButton.onPressed, isNotNull);
    },
  );

  testWidgets('adding a player past the max disables the add button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: NeverHaveIEverSetupPage()),
    );
    await tester.pumpAndSettle();

    for (
      var i = NeverHaveIEverConfig.minPlayers;
      i < NeverHaveIEverConfig.maxPlayers;
      i++
    ) {
      await tester.ensureVisible(find.text('Add player'));
      await tester.tap(find.text('Add player'));
      await tester.pumpAndSettle();
    }

    // Not asserting the full TextField count: the list is virtualized, so
    // rows scrolled out of the viewport aren't realized in the tree.
    expect(find.text('Add player'), findsNothing);
  });
}
