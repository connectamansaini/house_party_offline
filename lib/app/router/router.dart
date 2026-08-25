import 'package:go_router/go_router.dart';

import 'package:house_party_offline/src/home/presentation/home_page.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/game_setup.dart';
import 'package:house_party_offline/src/imposter_game/presentation/pages/game_page.dart';
import 'package:house_party_offline/src/imposter_game/presentation/pages/rules_page.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/presentation/pages/imposter_pack_editor_page.dart';
import 'package:house_party_offline/src/imposter_packs/presentation/pages/imposter_packs_page.dart';
import 'package:house_party_offline/src/imposter_setup/presentation/pages/imposter_home_page.dart';
import 'package:house_party_offline/src/imposter_setup/presentation/pages/imposter_setup_page.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_setup.dart';
import 'package:house_party_offline/src/mafia_game/presentation/pages/mafia_game_page.dart';
import 'package:house_party_offline/src/mafia_game/presentation/pages/rules_page.dart';
import 'package:house_party_offline/src/mafia_setup/presentation/pages/mafia_home_page.dart';
import 'package:house_party_offline/src/mafia_setup/presentation/pages/mafia_setup_page.dart';

/// Named routes. Kept as constants so navigation calls stay typo-safe.
abstract final class AppRoutes {
  static const home = '/';
  static const imposter = '/imposter';
  static const imposterSetup = '/imposter/setup';
  static const imposterGame = '/imposter/game';
  static const imposterPacks = '/imposter/packs';
  static const imposterPackEditor = '/imposter/packs/editor';
  static const imposterRules = '/imposter/rules';
  static const mafia = '/mafia';
  static const mafiaSetup = '/mafia/setup';
  static const mafiaGame = '/mafia/game';
  static const mafiaRules = '/mafia/rules';
}

/// Application router. The game route receives its [GameSetup] via `extra`.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.imposter,
      builder: (context, state) => const ImposterHomePage(),
    ),
    GoRoute(
      path: AppRoutes.imposterSetup,
      builder: (context, state) => const ImposterSetupPage(),
    ),
    GoRoute(
      path: AppRoutes.imposterGame,
      builder: (context, state) => GamePage(setup: state.extra! as GameSetup),
    ),
    GoRoute(
      path: AppRoutes.imposterPacks,
      builder: (context, state) => const ImposterPacksPage(),
    ),
    GoRoute(
      path: AppRoutes.imposterPackEditor,
      builder: (context, state) =>
          ImposterPackEditorPage(pack: state.extra as ImposterPackEntity?),
    ),
    GoRoute(
      path: AppRoutes.imposterRules,
      builder: (context, state) => const RulesPage(),
    ),
    GoRoute(
      path: AppRoutes.mafia,
      builder: (context, state) => const MafiaHomePage(),
    ),
    GoRoute(
      path: AppRoutes.mafiaSetup,
      builder: (context, state) => const MafiaSetupPage(),
    ),
    GoRoute(
      path: AppRoutes.mafiaGame,
      builder: (context, state) =>
          MafiaGamePage(setup: state.extra! as MafiaSetup),
    ),
    GoRoute(
      path: AppRoutes.mafiaRules,
      builder: (context, state) => const MafiaRulesPage(),
    ),
  ],
);
