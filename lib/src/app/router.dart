import 'package:go_router/go_router.dart';

import '../home/presentation/home_page.dart';
import '../imposter/domain/entities/game_setup.dart';
import '../imposter/presentation/game/pages/game_page.dart';
import '../imposter/presentation/setup/imposter_home_page.dart';
import '../imposter/domain/entities/word_pack.dart';
import '../imposter/presentation/packs/pages/pack_editor_page.dart';
import '../imposter/presentation/packs/pages/pack_list_page.dart';
import '../imposter/presentation/setup/pages/setup_page.dart';

/// Named routes. Kept as constants so navigation calls stay typo-safe.
abstract final class Routes {
  static const home = '/';
  static const imposter = '/imposter';
  static const imposterSetup = '/imposter/setup';
  static const imposterGame = '/imposter/game';
  static const imposterPacks = '/imposter/packs';
  static const imposterPackEditor = '/imposter/packs/editor';
}

/// Application router. The game route receives its [GameSetup] via `extra`.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: Routes.imposter,
      builder: (context, state) => const ImposterHomePage(),
    ),
    GoRoute(
      path: Routes.imposterSetup,
      builder: (context, state) => const SetupPage(),
    ),
    GoRoute(
      path: Routes.imposterGame,
      builder: (context, state) => GamePage(setup: state.extra! as GameSetup),
    ),
    GoRoute(
      path: Routes.imposterPacks,
      builder: (context, state) => const PackListPage(),
    ),
    GoRoute(
      path: Routes.imposterPackEditor,
      builder: (context, state) =>
          PackEditorPage(pack: state.extra as WordPack?),
    ),
  ],
);
