// Renders the Play Store screenshots in docs/store/screenshots from the real
// widgets, at 1080×1920 (9:16) with the app's fonts loaded.
//
// This is a generator, not a regression test, so it lives outside test/ and
// is run on demand:
//
//   flutter test tool/screenshots/store_screenshots_test.dart --update-goldens
//
// Role and prompt picks are random, so re-running changes the exact words on
// a few frames; that is fine for a listing.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/app/themes/app_theme.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';
import 'package:house_party_offline/src/heads_up/domain/engine/heads_up_engine.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_player.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_setup.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_ticker.dart';
import 'package:house_party_offline/src/heads_up/domain/heads_up_tilt_sensor.dart';
import 'package:house_party_offline/src/heads_up/presentation/pages/heads_up_game_page.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';
import 'package:house_party_offline/src/home/presentation/home_page.dart';
import 'package:house_party_offline/src/imposter_game/domain/engine/round_engine.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_config.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_setup.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/player.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/word_pack.dart';
import 'package:house_party_offline/src/imposter_game/presentation/pages/game_page.dart';
import 'package:house_party_offline/src/mafia_game/domain/engine/mafia_engine.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_player.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/pages/mafia_game_page.dart';
import 'package:house_party_offline/src/most_likely_to/domain/engine/most_likely_to_engine.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_player.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/pages/most_likely_to_game_page.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/pages/most_likely_to_setup_page.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/engine/never_have_i_ever_engine.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/pages/never_have_i_ever_game_page.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/engine/truth_or_dare_engine.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_player.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/pages/truth_or_dare_game_page.dart';

import '../../test/helpers/fake_custom_prompts_repository.dart';
import '../../test/helpers/fake_heads_up_clock.dart';
import '../../test/helpers/fake_review_gate.dart';
import '../../test/helpers/fake_roster_repository.dart';

const _names = ['Aman', 'Priya', 'Rohan', 'Neha', 'Karan', 'Simran', 'Vikram'];

const _foods = WordPack(
  id: 'foods',
  name: 'Food',
  category: 'Food',
  words: ['Biryani', 'Pizza', 'Momos', 'Dosa', 'Sushi', 'Samosa', 'Tacos'],
);

class _FakeRecentGames implements RecentGamesRepository {
  @override
  Future<String?> lastPlayedId() async => 'imposter';

  @override
  Future<void> markPlayed(String gameId) async {}
}

/// Widget tests ship with a placeholder font; pull in every family the app
/// bundles (and Material's icon font) so the frames look like the real app.
Future<void> _loadFonts() async {
  final manifest =
      json.decode(await rootBundle.loadString('FontManifest.json'))
          as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font
        in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

void main() {
  setUpAll(_loadFonts);

  late ManualHeadsUpTicker ticker;

  setUp(() {
    // The game pages keep the screen awake; there is no platform here, so
    // answer the plugin's channel with a successful empty reply.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
          'dev.flutter.pigeon.wakelock_plus_platform_interface.'
          'WakelockPlusApi.toggle',
          (_) async =>
              const StandardMessageCodec().encodeMessage(<Object?>[null]),
        );
    ticker = ManualHeadsUpTicker();
    getIt
      ..registerSingleton<RecentGamesRepository>(_FakeRecentGames())
      ..registerSingleton<RosterRepository>(FakeRosterRepository(_names))
      ..registerSingleton<CustomPromptsRepository>(
        FakeCustomPromptsRepository(),
      )
      ..registerFactory<RoundEngine>(RoundEngine.new)
      ..registerFactory<MafiaEngine>(MafiaEngine.new)
      ..registerFactory<NeverHaveIEverEngine>(NeverHaveIEverEngine.new)
      ..registerFactory<MostLikelyToEngine>(MostLikelyToEngine.new)
      ..registerFactory<TruthOrDareEngine>(TruthOrDareEngine.new)
      ..registerFactory<HeadsUpEngine>(HeadsUpEngine.new)
      ..registerSingleton<HeadsUpTicker>(ticker)
      ..registerSingleton<HeadsUpTiltSensor>(const NoHeadsUpTiltSensor());
    registerFakeReviewGate();
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpScreen(WidgetTester tester, Widget page) async {
    // 1080×1920 at a Pixel-like density: a 411×731 logical phone.
    tester.view
      ..physicalSize = const Size(1080, 1920)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        home: page,
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  Future<void> snap(WidgetTester tester, String file) => expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('../../docs/store/screenshots/$file.png'),
  );

  testWidgets('01 hub', (tester) async {
    await pumpScreen(tester, const HomePage());
    await snap(tester, '01-hub');
  });

  testWidgets('02 imposter', (tester) async {
    final setup = GameSetup(
      players: [
        for (final (i, name) in _names.take(5).indexed)
          Player(id: 'p$i', name: name),
      ],
      config: const GameConfig(packs: [_foods]),
    );
    await pumpScreen(tester, GamePage(setup: setup));
    await tap(tester, "I'm Aman — reveal");
    await snap(tester, '02-imposter');
  });

  testWidgets('03 mafia', (tester) async {
    final setup = MafiaSetup(
      players: [
        for (final (i, name) in _names.indexed)
          MafiaPlayer(id: 'p$i', name: name),
      ],
      config: const MafiaConfig(),
    );
    await pumpScreen(tester, MafiaGamePage(setup: setup));
    await tap(tester, "I'm Aman — reveal role");
    await snap(tester, '03-mafia');
  });

  testWidgets('04 never have i ever', (tester) async {
    final setup = NeverHaveIEverSetup(
      players: [
        for (final (i, name) in _names.take(4).indexed)
          NeverHaveIEverPlayer(id: 'p$i', name: name),
      ],
      config: const NeverHaveIEverConfig(),
    );
    await pumpScreen(tester, NeverHaveIEverGamePage(setup: setup));
    await tap(tester, 'Priya');
    await snap(tester, '04-never-have-i-ever');
  });

  testWidgets('05 most likely to', (tester) async {
    final setup = MostLikelyToSetup(
      players: [
        for (final (i, name) in _names.take(4).indexed)
          MostLikelyToPlayer(id: 'p$i', name: name),
      ],
      config: const MostLikelyToConfig(),
    );
    await pumpScreen(tester, MostLikelyToGamePage(setup: setup));
    await tap(tester, 'Rohan');
    await snap(tester, '05-most-likely-to');
  });

  testWidgets('06 truth or dare', (tester) async {
    final setup = TruthOrDareSetup(
      players: [
        for (final (i, name) in _names.take(4).indexed)
          TruthOrDarePlayer(id: 'p$i', name: name),
      ],
      config: const TruthOrDareConfig(),
    );
    await pumpScreen(tester, TruthOrDareGamePage(setup: setup));
    await tap(tester, 'Dare');
    await snap(tester, '06-truth-or-dare');
  });

  testWidgets('07 heads up', (tester) async {
    final setup = HeadsUpSetup(
      players: [
        for (final (i, name) in _names.take(4).indexed)
          HeadsUpPlayer(id: 'p$i', name: name),
      ],
      config: const HeadsUpConfig(),
      words: _foods.words,
    );
    await pumpScreen(tester, HeadsUpGamePage(setup: setup));
    await tap(tester, 'Start my turn');
    ticker.runDown(from: HeadsUpConfig.countdownSeconds);
    await tester.pumpAndSettle();
    await snap(tester, '07-heads-up');
  });

  testWidgets('08 roster', (tester) async {
    await pumpScreen(tester, const MostLikelyToSetupPage());
    await snap(tester, '08-roster');
  });
}
