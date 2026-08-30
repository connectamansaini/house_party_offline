import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/engine/never_have_i_ever_engine.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/pages/never_have_i_ever_game_page.dart';

/// Exercises the real, wired-up [NeverHaveIEverGamePage] — selecting a
/// player, confirming a round, and reaching the winner screen — the same
/// widget tree a live match renders.
void main() {
  setUp(() {
    getIt.registerFactory<NeverHaveIEverEngine>(NeverHaveIEverEngine.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  const setup = NeverHaveIEverSetup(
    players: [
      NeverHaveIEverPlayer(id: 'p0', name: 'Ann'),
      NeverHaveIEverPlayer(id: 'p1', name: 'Bo'),
    ],
    config: NeverHaveIEverConfig(livesPerPlayer: 1),
  );

  testWidgets('eliminating one player of two ends the match with a winner', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: NeverHaveIEverGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Never Have I Ever'), findsOneWidget);
    expect(find.text('Ann'), findsOneWidget);
    expect(find.text('Bo'), findsOneWidget);

    await tester.tap(find.text('Ann'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm & continue'));
    await tester.pumpAndSettle();

    expect(find.text('Bo wins!'), findsOneWidget);
    expect(find.text('Game over'), findsOneWidget);
  });

  testWidgets('quitting asks for confirmation before leaving', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: NeverHaveIEverGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Quit game'));
    await tester.pumpAndSettle();

    expect(find.text('Quit game?'), findsOneWidget);
    expect(find.text('This match will end.'), findsOneWidget);
  });
}
