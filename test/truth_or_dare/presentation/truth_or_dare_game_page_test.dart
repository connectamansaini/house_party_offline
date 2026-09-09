import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/engine/truth_or_dare_engine.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/pages/truth_or_dare_game_page.dart';
import '../../helpers/fake_review_gate.dart';

/// Exercises the real, wired-up [TruthOrDareGamePage] through a full
/// one-round match: choose, face the prompt, resolve, next player, winner.
void main() {
  setUp(() {
    getIt.registerFactory<TruthOrDareEngine>(TruthOrDareEngine.new);
    registerFakeReviewGate();
  });

  tearDown(() async {
    await getIt.reset();
  });

  const setup = TruthOrDareSetup(
    players: [
      TruthOrDarePlayer(id: 'p0', name: 'Ann'),
      TruthOrDarePlayer(id: 'p1', name: 'Bo'),
    ],
    config: TruthOrDareConfig(roundCount: 1),
  );

  testWidgets('a completed turn beats a skipped one', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: TruthOrDareGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Truth or Dare'), findsOneWidget);
    expect(find.text('Ann, truth or dare?'), findsOneWidget);

    await tester.tap(find.text('Truth'));
    await tester.pumpAndSettle();
    expect(find.text('Truth for Ann'), findsOneWidget);

    await tester.tap(find.text('Done — take the point'));
    await tester.pumpAndSettle();
    expect(find.text('Bo, truth or dare?'), findsOneWidget);

    await tester.tap(find.text('Dare'));
    await tester.pumpAndSettle();
    expect(find.text('Dare for Bo'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Game over'), findsOneWidget);
    expect(find.text('Ann wins!'), findsOneWidget);
  });

  testWidgets('quitting asks for confirmation before leaving', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: TruthOrDareGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Quit game'));
    await tester.pumpAndSettle();

    expect(find.text('Quit game?'), findsOneWidget);
  });
}
