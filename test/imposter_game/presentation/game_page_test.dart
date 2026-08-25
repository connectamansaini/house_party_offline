import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/imposter_game/domain/engine/round_engine.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_setup.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/word_pack.dart';
import 'package:house_party_offline/src/imposter_game/presentation/pages/game_page.dart';

/// Exercises the real, wired-up [GamePage] — role reveal through a full
/// pass-and-play round — the same widget tree a live game renders, just
/// without a browser. The FSM's branching logic itself is covered
/// exhaustively by `game_bloc_test.dart`; this is about the widget
/// composition (gradients, `AnimatedSwitcher`, dialogs) those tests never
/// touch.
void main() {
  setUp(() {
    getIt.registerFactory<RoundEngine>(RoundEngine.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  const setup = GameSetup(
    players: [
      Player(id: 'p0', name: 'Ann'),
      Player(id: 'p1', name: 'Bo'),
      Player(id: 'p2', name: 'Cy'),
    ],
    config: GameConfig(
      packs: [
        WordPack(id: 'x', name: 'X', category: 'Cat', words: ['Word']),
      ],
      discussionTime: Duration(seconds: 1),
    ),
  );

  testWidgets('reveals the first player, then passes to the next', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GamePage(setup: setup)));
    await tester.pumpAndSettle();

    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Pass the phone to'), findsOneWidget);
    expect(find.text('Ann'), findsOneWidget);

    await tester.tap(find.text("I'm Ann — reveal"));
    await tester.pumpAndSettle();
    // Ann's role is randomly assigned (no seeded rng), so accept either the
    // civilian or the imposter reveal.
    expect(
      find.text('Your secret word').evaluate().isNotEmpty ||
          find.textContaining('IMPOSTER').evaluate().isNotEmpty,
      isTrue,
    );

    await tester.tap(find.text('Hide & pass'));
    await tester.pumpAndSettle();
    expect(find.text('Bo'), findsOneWidget);
  });

  testWidgets('quitting asks for confirmation before leaving', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GamePage(setup: setup)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Quit game'));
    await tester.pumpAndSettle();

    expect(find.text('Quit game?'), findsOneWidget);
    expect(find.text('Scores for this game will be lost.'), findsOneWidget);
  });
}
