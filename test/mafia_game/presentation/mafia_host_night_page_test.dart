import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/core/widgets/selectable_player_tile.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/pages/mafia_game_page.dart';

import '../../helpers/fake_review_gate.dart';

/// Drives the real [MafiaGamePage] with a narrator: the host-run night is a
/// different widget tree from pass-and-play, and this is the only test that
/// renders it.
void main() {
  setUp(() {
    getIt.registerFactory<MafiaEngine>(MafiaEngine.new);
    registerFakeReviewGate();
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
    host: MafiaPlayer(id: 'h', name: 'Zara'),
  );

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  testWidgets('the host shows each role, then opens the night', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MafiaGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    // The narrator holds the phone, so the prompts address them.
    expect(find.text('Take the phone to'), findsOneWidget);
    expect(find.text('Ann'), findsOneWidget);
    await tap(tester, 'Show Ann their role');
    await tap(tester, 'Hide & move on');

    expect(find.text('Bo'), findsOneWidget);
    for (final name in ['Bo', 'Cy', 'Di']) {
      await tap(tester, 'Show $name their role');
      await tap(tester, 'Hide & move on');
    }
    await tap(tester, 'Show Ed their role');
    await tap(tester, 'Begin night 1');

    expect(find.text('Everyone, close your eyes.'), findsOneWidget);
    expect(find.textContaining('Zara is narrating'), findsOneWidget);
  });

  testWidgets('the night is a script of steps, not a round of passing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MafiaGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();
    for (final name in ['Ann', 'Bo', 'Cy', 'Di']) {
      await tap(tester, 'Show $name their role');
      await tap(tester, 'Hide & move on');
    }
    await tap(tester, 'Show Ed their role');
    await tap(tester, 'Begin night 1');

    // The rail lays out the whole night before it starts.
    for (final role in ['Mafia', 'Doctor', 'Detective']) {
      expect(find.text(role), findsOneWidget);
    }

    await tap(tester, 'Start the night');
    expect(find.text('Mafia, open your eyes.'), findsOneWidget);
    expect(find.text('READ ALOUD'), findsOneWidget);
    // The host is told who should be awake.
    expect(find.textContaining('Awake:'), findsOneWidget);

    // Nothing is recorded until the host taps who was pointed at.
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Tap who they pointed at'),
          )
          .onPressed,
      isNull,
    );

    // Roles are dealt at random, so pick whoever the list offers.
    await tester.tap(find.byType(SelectablePlayerTile).first);
    await tester.pumpAndSettle();

    // The button names the consequence once someone is picked.
    expect(find.textContaining('Kill '), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Doctor, open your eyes.'), findsOneWidget);
  });
}
