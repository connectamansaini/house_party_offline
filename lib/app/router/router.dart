import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:house_party_offline/core/design/app_motion.dart';
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
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_setup.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/pages/most_likely_to_game_page.dart';
import 'package:house_party_offline/src/most_likely_to/presentation/pages/rules_page.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/pages/most_likely_to_home_page.dart';
import 'package:house_party_offline/src/most_likely_to_setup/presentation/pages/most_likely_to_setup_page.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_setup.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/pages/never_have_i_ever_game_page.dart';
import 'package:house_party_offline/src/never_have_i_ever/presentation/pages/rules_page.dart';
import 'package:house_party_offline/src/never_have_i_ever_setup/presentation/pages/never_have_i_ever_home_page.dart';
import 'package:house_party_offline/src/never_have_i_ever_setup/presentation/pages/never_have_i_ever_setup_page.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_setup.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/pages/rules_page.dart';
import 'package:house_party_offline/src/truth_or_dare/presentation/pages/truth_or_dare_game_page.dart';
import 'package:house_party_offline/src/truth_or_dare_setup/presentation/pages/truth_or_dare_home_page.dart';
import 'package:house_party_offline/src/truth_or_dare_setup/presentation/pages/truth_or_dare_setup_page.dart';

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
  static const neverHaveIEver = '/never-have-i-ever';
  static const neverHaveIEverSetup = '/never-have-i-ever/setup';
  static const neverHaveIEverGame = '/never-have-i-ever/game';
  static const neverHaveIEverRules = '/never-have-i-ever/rules';
  static const mostLikelyTo = '/most-likely-to';
  static const mostLikelyToSetup = '/most-likely-to/setup';
  static const mostLikelyToGame = '/most-likely-to/game';
  static const mostLikelyToRules = '/most-likely-to/rules';
  static const truthOrDare = '/truth-or-dare';
  static const truthOrDareSetup = '/truth-or-dare/setup';
  static const truthOrDareGame = '/truth-or-dare/game';
  static const truthOrDareRules = '/truth-or-dare/rules';
}

/// Every route uses the same short fade-and-rise so navigation feels like
/// one system, instead of the platform's default zoom.
CustomTransitionPage<T> _page<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.base,
    reverseTransitionDuration: AppMotion.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppMotion.curve,
        reverseCurve: AppMotion.reverseCurve,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Application router. Game routes receive their setup via `extra`.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => _page(state, const HomePage()),
    ),
    GoRoute(
      path: AppRoutes.imposter,
      pageBuilder: (context, state) => _page(state, const ImposterHomePage()),
    ),
    GoRoute(
      path: AppRoutes.imposterSetup,
      pageBuilder: (context, state) => _page(state, const ImposterSetupPage()),
    ),
    GoRoute(
      path: AppRoutes.imposterGame,
      pageBuilder: (context, state) =>
          _page(state, GamePage(setup: state.extra! as GameSetup)),
    ),
    GoRoute(
      path: AppRoutes.imposterPacks,
      pageBuilder: (context, state) => _page(state, const ImposterPacksPage()),
    ),
    GoRoute(
      path: AppRoutes.imposterPackEditor,
      pageBuilder: (context, state) => _page<bool>(
        state,
        ImposterPackEditorPage(pack: state.extra as ImposterPackEntity?),
      ),
    ),
    GoRoute(
      path: AppRoutes.imposterRules,
      pageBuilder: (context, state) => _page(state, const RulesPage()),
    ),
    GoRoute(
      path: AppRoutes.mafia,
      pageBuilder: (context, state) => _page(state, const MafiaHomePage()),
    ),
    GoRoute(
      path: AppRoutes.mafiaSetup,
      pageBuilder: (context, state) => _page(state, const MafiaSetupPage()),
    ),
    GoRoute(
      path: AppRoutes.mafiaGame,
      pageBuilder: (context, state) =>
          _page(state, MafiaGamePage(setup: state.extra! as MafiaSetup)),
    ),
    GoRoute(
      path: AppRoutes.mafiaRules,
      pageBuilder: (context, state) => _page(state, const MafiaRulesPage()),
    ),
    GoRoute(
      path: AppRoutes.neverHaveIEver,
      pageBuilder: (context, state) =>
          _page(state, const NeverHaveIEverHomePage()),
    ),
    GoRoute(
      path: AppRoutes.neverHaveIEverSetup,
      pageBuilder: (context, state) =>
          _page(state, const NeverHaveIEverSetupPage()),
    ),
    GoRoute(
      path: AppRoutes.neverHaveIEverGame,
      pageBuilder: (context, state) => _page(
        state,
        NeverHaveIEverGamePage(setup: state.extra! as NeverHaveIEverSetup),
      ),
    ),
    GoRoute(
      path: AppRoutes.neverHaveIEverRules,
      pageBuilder: (context, state) =>
          _page(state, const NeverHaveIEverRulesPage()),
    ),
    GoRoute(
      path: AppRoutes.mostLikelyTo,
      pageBuilder: (context, state) =>
          _page(state, const MostLikelyToHomePage()),
    ),
    GoRoute(
      path: AppRoutes.mostLikelyToSetup,
      pageBuilder: (context, state) =>
          _page(state, const MostLikelyToSetupPage()),
    ),
    GoRoute(
      path: AppRoutes.mostLikelyToGame,
      pageBuilder: (context, state) => _page(
        state,
        MostLikelyToGamePage(setup: state.extra! as MostLikelyToSetup),
      ),
    ),
    GoRoute(
      path: AppRoutes.mostLikelyToRules,
      pageBuilder: (context, state) =>
          _page(state, const MostLikelyToRulesPage()),
    ),
    GoRoute(
      path: AppRoutes.truthOrDare,
      pageBuilder: (context, state) =>
          _page(state, const TruthOrDareHomePage()),
    ),
    GoRoute(
      path: AppRoutes.truthOrDareSetup,
      pageBuilder: (context, state) =>
          _page(state, const TruthOrDareSetupPage()),
    ),
    GoRoute(
      path: AppRoutes.truthOrDareGame,
      pageBuilder: (context, state) => _page(
        state,
        TruthOrDareGamePage(setup: state.extra! as TruthOrDareSetup),
      ),
    ),
    GoRoute(
      path: AppRoutes.truthOrDareRules,
      pageBuilder: (context, state) =>
          _page(state, const TruthOrDareRulesPage()),
    ),
  ],
);
