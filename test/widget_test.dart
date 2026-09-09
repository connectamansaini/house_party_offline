import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';
import 'package:house_party_offline/src/home/presentation/home_page.dart';

class _FakeRecentGames implements RecentGamesRepository {
  _FakeRecentGames([this.stored]);

  String? stored;

  @override
  Future<String?> lastPlayedId() async => stored;

  @override
  Future<void> markPlayed(String gameId) async => stored = gameId;
}

/// Pumps the hub inside a minimal router: cards navigate with `context.push`,
/// so every game route needs to resolve, but to a stub, not the real page.
Future<void> _pumpHub(WidgetTester tester) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      for (final game in GameCatalog.games) ...[
        GoRoute(
          path: game.route,
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: game.setupRoute,
          builder: (context, state) => const Placeholder(),
        ),
      ],
    ],
  );
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('first run features "start here" and lists every game', (
    tester,
  ) async {
    getIt.registerSingleton<RecentGamesRepository>(_FakeRecentGames());

    await _pumpHub(tester);

    expect(find.text('House Party'), findsOneWidget);
    expect(find.text('START HERE'), findsOneWidget);
    expect(find.text('Set up a game'), findsOneWidget);
    expect(find.text('All games'), findsOneWidget);

    // Imposter is both the featured suggestion and a grid card.
    expect(find.text('Imposter'), findsNWidgets(2));
    expect(find.text('Mafia'), findsOneWidget);
    expect(find.text('Never Have I Ever'), findsOneWidget);

    // The last grid row can sit below the test viewport; the hub's ListView
    // is lazy, so scroll it into view before asserting.
    await tester.dragUntilVisible(
      find.text('Most Likely To'),
      find.byType(ListView),
      const Offset(0, -200),
    );
    expect(find.text('Most Likely To'), findsOneWidget);
  });

  testWidgets('a previously played game is featured as "jump back in"', (
    tester,
  ) async {
    getIt.registerSingleton<RecentGamesRepository>(_FakeRecentGames('mafia'));

    await _pumpHub(tester);

    expect(find.text('JUMP BACK IN'), findsOneWidget);
    expect(find.text('Play again'), findsOneWidget);
    expect(find.text('Mafia'), findsNWidgets(2));
    expect(find.text('START HERE'), findsNothing);
  });

  testWidgets('the About action opens the info sheet', (tester) async {
    getIt.registerSingleton<RecentGamesRepository>(_FakeRecentGames());

    await _pumpHub(tester);

    await tester.tap(find.byTooltip('About'));
    await tester.pumpAndSettle();

    expect(find.text('Works fully offline'), findsOneWidget);
    expect(find.text('One phone for the room'), findsOneWidget);
    expect(
      find.text('${GameCatalog.games.length} games and counting'),
      findsOneWidget,
    );
  });

  testWidgets('opening a game from the grid remembers it', (tester) async {
    final repo = _FakeRecentGames();
    getIt.registerSingleton<RecentGamesRepository>(repo);

    await _pumpHub(tester);

    // Grid cards are tall relative to the test viewport; the card is built
    // (the grid isn't lazy) but off-screen, so a tap would silently miss.
    await tester.ensureVisible(find.text('Mafia'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mafia'));
    await tester.pumpAndSettle();

    expect(repo.stored, 'mafia');
  });
}
