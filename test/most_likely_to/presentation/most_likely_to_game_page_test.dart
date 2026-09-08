import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/pages/most_likely_to_game_page.dart';

/// Exercises the real, wired-up [MostLikelyToGamePage] — selecting a player,
/// confirming a round, and reaching the winner screen — the same widget tree
/// a live match renders.
void main() {
  setUp(() {
    getIt.registerFactory<MostLikelyToEngine>(MostLikelyToEngine.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  const setup = MostLikelyToSetup(
    players: [
      MostLikelyToPlayer(id: 'p0', name: 'Ann'),
      MostLikelyToPlayer(id: 'p1', name: 'Bo'),
      MostLikelyToPlayer(id: 'p2', name: 'Cy'),
    ],
    config: MostLikelyToConfig(roundCount: MostLikelyToConfig.minRounds),
  );

  testWidgets('scoring the same player every round makes them the winner', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MostLikelyToGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Most Likely To'), findsOneWidget);
    expect(
      find.text('Round 1 of ${MostLikelyToConfig.minRounds}'),
      findsOneWidget,
    );
    expect(find.text('Ann'), findsOneWidget);
    expect(find.text('Bo'), findsOneWidget);
    expect(find.text('Cy'), findsOneWidget);

    for (var round = 0; round < MostLikelyToConfig.minRounds; round++) {
      await tester.tap(find.text('Ann'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm & continue'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Ann wins!'), findsOneWidget);
    expect(find.text('Game over'), findsOneWidget);
    expect(find.text('${MostLikelyToConfig.minRounds} pts'), findsOneWidget);
  });

  testWidgets('quitting asks for confirmation before leaving', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MostLikelyToGamePage(setup: setup)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Quit game'));
    await tester.pumpAndSettle();

    expect(find.text('Quit game?'), findsOneWidget);
    expect(find.text('This match will end.'), findsOneWidget);
  });
}
