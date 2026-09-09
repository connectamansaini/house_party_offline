import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/app/themes/app_theme.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';
import 'package:house_party_offline/src/home/presentation/home_page.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/pages/most_likely_to_game_page.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/pages/most_likely_to_home_page.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/pages/most_likely_to_setup_page.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';

import '../helpers/fake_custom_prompts_repository.dart';
import '../helpers/fake_review_gate.dart';
import '../helpers/fake_roster_repository.dart';

class _FakeRecentGames implements RecentGamesRepository {
  @override
  Future<String?> lastPlayedId() async => 'mafia';

  @override
  Future<void> markPlayed(String gameId) async {}
}

/// The main screens at the large text sizes people actually use. A RenderFlex
/// overflow surfaces as a test error, so any layout that can't take bigger
/// type fails here before it fails on a phone.
void main() {
  setUp(() {
    getIt
      ..registerSingleton<RecentGamesRepository>(_FakeRecentGames())
      ..registerSingleton<RosterRepository>(FakeRosterRepository())
      ..registerSingleton<CustomPromptsRepository>(
        FakeCustomPromptsRepository(),
      )
      ..registerFactory<MostLikelyToEngine>(MostLikelyToEngine.new);
    registerFakeReviewGate();
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpAt(
    WidgetTester tester,
    double scale,
    Widget page, {
    Size viewport = const Size(390, 844),
  }) async {
    await tester.binding.setSurfaceSize(viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      routes: [
        GoRoute(path: AppRoutes.home, builder: (_, _) => page),
        for (final game in GameCatalog.games) ...[
          GoRoute(path: game.route, builder: (_, _) => const Placeholder()),
          GoRoute(
            path: game.setupRoute,
            builder: (_, _) => const Placeholder(),
          ),
        ],
      ],
    );
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: viewport,
          textScaler: TextScaler.linear(scale),
        ),
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  const setup = MostLikelyToSetup(
    players: [
      MostLikelyToPlayer(id: 'p0', name: 'Alexandria'),
      MostLikelyToPlayer(id: 'p1', name: 'Bartholomew'),
      MostLikelyToPlayer(id: 'p2', name: 'Cy'),
    ],
    config: MostLikelyToConfig(roundCount: MostLikelyToConfig.minRounds),
  );

  for (final scale in [1.3, 1.6]) {
    group('at ${scale}x text', () {
      testWidgets('the hub lays out', (tester) async {
        await pumpAt(tester, scale, const HomePage());
        expect(find.text('House Party'), findsOneWidget);
      });

      testWidgets('a landing page lays out', (tester) async {
        await pumpAt(tester, scale, const MostLikelyToHomePage());
        expect(find.text('New game'), findsOneWidget);
      });

      testWidgets('a setup page lays out', (tester) async {
        await pumpAt(tester, scale, const MostLikelyToSetupPage());
        expect(find.text('Start game'), findsOneWidget);
      });

      testWidgets('a game page lays out through to game over', (tester) async {
        await pumpAt(tester, scale, const MostLikelyToGamePage(setup: setup));
        for (var i = 0; i < MostLikelyToConfig.minRounds; i++) {
          await tester.tap(find.text('Alexandria'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Confirm & continue'));
          await tester.pumpAndSettle();
        }
        expect(find.text('Alexandria wins!'), findsOneWidget);
      });
    });
  }
}
