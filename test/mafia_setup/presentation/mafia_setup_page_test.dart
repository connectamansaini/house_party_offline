import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_setup/domain/repositories/mafia_host_preferences_repository.dart';
import 'package:house_party_offline/src/mafia_setup/presentation/pages/mafia_setup_page.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import '../../helpers/fake_mafia_host_preferences_repository.dart';
import '../../helpers/fake_roster_repository.dart';

/// Exercises the real, wired-up [MafiaSetupPage] end to end — the roster
/// list, the options, and the Start button — the same path a live app
/// takes, just without a browser.
void main() {
  setUp(() {
    getIt
      ..registerSingleton<RosterRepository>(FakeRosterRepository())
      ..registerSingleton<MafiaHostPreferencesRepository>(
        FakeMafiaHostPreferencesRepository(),
      );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'renders the default roster and options, with Start game enabled',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MafiaSetupPage()));
      await tester.pumpAndSettle();

      expect(find.text('Players'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(MafiaConfig.minPlayers));
      expect(find.text('Options'), findsOneWidget);

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
    await tester.pumpWidget(const MaterialApp(home: MafiaSetupPage()));
    await tester.pumpAndSettle();

    for (var i = MafiaConfig.minPlayers; i < MafiaConfig.maxPlayers; i++) {
      await tester.ensureVisible(find.text('Add player'));
      await tester.tap(find.text('Add player'));
      await tester.pumpAndSettle();
    }

    // Not asserting the full TextField count: the list is virtualized, so
    // rows scrolled out of the viewport aren't realized in the tree.
    expect(find.text('Add player'), findsNothing);
  });

  testWidgets('turning on host mode asks who hosts and blocks Start', (
    tester,
  ) async {
    // A tall surface so the whole form renders: the roster list is lazy, and
    // an option scrolled to the viewport edge can't be tapped reliably.
    tester.view
      ..physicalSize = const Size(1200, 3000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: MafiaSetupPage()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(SwitchListTile, 'Host runs the night'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Who is hosting?'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNWidgets(MafiaConfig.minPlayers));
    expect(find.text('Host — no role'), findsOneWidget);
    expect(
      find.widgetWithText(SwitchListTile, 'Rotate the host'),
      findsOneWidget,
    );
    expect(find.text('The same person hosts every game'), findsOneWidget);

    // The narrator sits out, leaving the game one player short.
    expect(find.textContaining('plus the host'), findsOneWidget);
    expect(_startButton(tester).onPressed, isNull);

    await tester.tap(find.text('Add player'));
    await tester.pumpAndSettle();
    expect(_startButton(tester).onPressed, isNotNull);

    await tester.tap(find.widgetWithText(SwitchListTile, 'Rotate the host'));
    await tester.pumpAndSettle();
    expect(
      find.text('Next game hands narrating to the next person on the list'),
      findsOneWidget,
    );
  });

  testWidgets('pass-and-play hides the host picker and rotation', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MafiaSetupPage()));
    await tester.pumpAndSettle();

    expect(find.text('Who is hosting?'), findsNothing);
    expect(
      find.widgetWithText(SwitchListTile, 'Rotate the host'),
      findsNothing,
    );
  });
}

FilledButton _startButton(WidgetTester tester) => tester.widget<FilledButton>(
  find.ancestor(
    of: find.text('Start game'),
    matching: find.byType(FilledButton),
  ),
);
