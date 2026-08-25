import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/pages/mafia_game_page.dart';

/// Exercises the real, wired-up [MafiaGamePage] — role reveal through the
/// pass-and-play loop — the same widget tree a live match renders, just
/// without a browser. The FSM's branching logic itself is covered
/// exhaustively by `mafia_game_bloc_test.dart`; this is about the widget
/// composition (gradients, `AnimatedSwitcher`, dialogs) those tests never
/// touch.
void main() {
  setUp(() {
    getIt.registerFactory<MafiaEngine>(MafiaEngine.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  const setup = MafiaSetup(
    players: [
      MafiaPlayer(id: 'p0', name: 'Ann'),
      MafiaPlayer(id: 'p1', name: 'Bo'),
      MafiaPlayer(id: 'p2', name: 'Cy'),
      MafiaPlayer(id: 'p3', name: 'Di'),
      MafiaPlayer(id: 'p4', name: 'Ed'),
    ],
    config: MafiaConfig(),
  );

  testWidgets('reveals the first player, then passes to the next', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MafiaGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Role reveal'), findsOneWidget);
    expect(find.text('Pass the phone to'), findsOneWidget);
    expect(find.text('Ann'), findsOneWidget);

    await tester.tap(find.text("I'm Ann — reveal role"));
    await tester.pumpAndSettle();
    expect(find.text('You are'), findsOneWidget);

    await tester.tap(find.text('Hide & pass'));
    await tester.pumpAndSettle();
    expect(find.text('Bo'), findsOneWidget);
  });

  testWidgets('quitting asks for confirmation before leaving', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MafiaGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Quit game'));
    await tester.pumpAndSettle();

    expect(find.text('Quit game?'), findsOneWidget);
    expect(find.text('This match will end.'), findsOneWidget);
  });
}
