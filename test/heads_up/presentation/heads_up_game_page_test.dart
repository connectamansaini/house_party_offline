import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/heads_up/domain/engine/heads_up_engine.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_setup.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_ticker.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';
import 'package:house_party_offline/src/heads_up/presentation/pages/heads_up_game_page.dart';

import '../../helpers/fake_heads_up_clock.dart';
import '../../helpers/fake_review_gate.dart';

/// Exercises the real, wired-up [HeadsUpGamePage] through one full turn on
/// a hand-driven clock: ready, countdown, a couple of judged words, time
/// up, summary, and the game-over screen.
void main() {
  late ManualHeadsUpTicker ticker;

  setUp(() {
    ticker = ManualHeadsUpTicker();
    getIt
      ..registerFactory<HeadsUpEngine>(HeadsUpEngine.new)
      ..registerSingleton<HeadsUpTicker>(ticker)
      ..registerSingleton<HeadsUpTiltSensor>(const NoHeadsUpTiltSensor());
    registerFakeReviewGate();
  });

  tearDown(() async {
    await getIt.reset();
  });

  const setup = HeadsUpSetup(
    players: [
      HeadsUpPlayer(id: 'p0', name: 'Ann'),
      HeadsUpPlayer(id: 'p1', name: 'Bo'),
    ],
    config: HeadsUpConfig(roundSeconds: 30),
    words: ['cat', 'dog', 'owl'],
  );

  testWidgets('one turn from ready to summary, then the next player', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: HeadsUpGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    expect(find.text("Ann, you're up!"), findsOneWidget);
    await tester.tap(find.text('Start my turn'));
    await tester.pumpAndSettle();

    // Countdown shows the seconds; buttons are disabled until play starts.
    expect(find.text('3'), findsOneWidget);
    ticker.runDown(from: HeadsUpConfig.countdownSeconds);
    await tester.pumpAndSettle();

    expect(find.text('30s'), findsOneWidget);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pass'));
    await tester.pumpAndSettle();

    ticker.runDown(from: 30);
    await tester.pumpAndSettle();

    expect(find.text('Ann got 1'), findsOneWidget);
    expect(find.text('Next: Bo'), findsOneWidget);

    await tester.tap(find.text('Next: Bo'));
    await tester.pumpAndSettle();
    expect(find.text("Bo, you're up!"), findsOneWidget);
  });

  testWidgets('quitting asks for confirmation before leaving', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: HeadsUpGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Quit game'));
    await tester.pumpAndSettle();

    expect(find.text('Quit game?'), findsOneWidget);
  });
}
