import 'package:flutter/material.dart';
import 'package:house_party_offline/app/router/router.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/heads_up/domain/entities/heads_up_config.dart';
import 'package:house_party_offline/src/imposter_setup/presentation/bloc/imposter_setup_bloc.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_config.dart';
import 'package:house_party_offline/src/most_likely_to/domain/entities/most_likely_to_config.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_config.dart';
import 'package:house_party_offline/src/truth_or_dare/domain/entities/truth_or_dare_config.dart';

/// One entry in the games hub: everything the home screen needs to present
/// a game and route into it. Player ranges come from each game's own config
/// so the hub can never drift from the setup screens.
class HomeGame {
  const HomeGame({
    required this.id,
    required this.title,
    required this.blurb,
    required this.tag,
    required this.icon,
    required this.gradient,
    required this.minPlayers,
    required this.maxPlayers,
    required this.minutes,
    required this.route,
    required this.setupRoute,
  });

  /// Stable key, persisted as the "last played" game — never rename.
  final String id;
  final String title;
  final String blurb;

  /// One-word category shown as a label on the card.
  final String tag;
  final IconData icon;

  /// Only its first stop is used, as the accent (see [AppColors.accentOf]).
  final Gradient gradient;
  final int minPlayers;
  final int maxPlayers;

  /// Rough length of one match, for the meta line.
  final int minutes;

  /// The game's landing page (rules, packs, new game).
  final String route;

  /// Straight into player setup — used by the "Play again" shortcut.
  final String setupRoute;

  String get playersLabel => '$minPlayers–$maxPlayers';
}

/// The fixed list of games in the app, in display order.
abstract final class GameCatalog {
  static const games = [
    HomeGame(
      id: 'imposter',
      title: AppStrings.imposterName,
      blurb: AppStrings.imposterBlurb,
      tag: 'Bluffing',
      icon: Icons.theater_comedy_outlined,
      gradient: AppColors.imposterGradient,
      minPlayers: ImposterSetupState.minPlayers,
      maxPlayers: ImposterSetupState.maxPlayers,
      minutes: 10,
      route: AppRoutes.imposter,
      setupRoute: AppRoutes.imposterSetup,
    ),
    HomeGame(
      id: 'mafia',
      title: AppStrings.mafiaName,
      blurb: AppStrings.mafiaBlurb,
      tag: 'Deduction',
      icon: Icons.dangerous_outlined,
      gradient: AppColors.mafiaGradient,
      minPlayers: MafiaConfig.minPlayers,
      maxPlayers: MafiaConfig.maxPlayers,
      minutes: 20,
      route: AppRoutes.mafia,
      setupRoute: AppRoutes.mafiaSetup,
    ),
    HomeGame(
      id: 'never_have_i_ever',
      title: AppStrings.neverHaveIEverName,
      blurb: AppStrings.neverHaveIEverBlurb,
      tag: 'Icebreaker',
      icon: Icons.record_voice_over_rounded,
      gradient: AppColors.confessionGradient,
      minPlayers: NeverHaveIEverConfig.minPlayers,
      maxPlayers: NeverHaveIEverConfig.maxPlayers,
      minutes: 10,
      route: AppRoutes.neverHaveIEver,
      setupRoute: AppRoutes.neverHaveIEverSetup,
    ),
    HomeGame(
      id: 'most_likely_to',
      title: AppStrings.mostLikelyToName,
      blurb: AppStrings.mostLikelyToBlurb,
      tag: 'Voting',
      icon: Icons.how_to_vote_rounded,
      gradient: AppColors.spotlightGradient,
      minPlayers: MostLikelyToConfig.minPlayers,
      maxPlayers: MostLikelyToConfig.maxPlayers,
      minutes: 10,
      route: AppRoutes.mostLikelyTo,
      setupRoute: AppRoutes.mostLikelyToSetup,
    ),
    HomeGame(
      id: 'truth_or_dare',
      title: AppStrings.truthOrDareName,
      blurb: AppStrings.truthOrDareBlurb,
      tag: 'Party',
      icon: Icons.local_fire_department_rounded,
      gradient: AppColors.dareGradient,
      minPlayers: TruthOrDareConfig.minPlayers,
      maxPlayers: TruthOrDareConfig.maxPlayers,
      minutes: 15,
      route: AppRoutes.truthOrDare,
      setupRoute: AppRoutes.truthOrDareSetup,
    ),
    HomeGame(
      id: 'heads_up',
      title: AppStrings.headsUpName,
      blurb: AppStrings.headsUpBlurb,
      tag: 'Guessing',
      icon: Icons.emoji_people_rounded,
      gradient: AppColors.signalGradient,
      minPlayers: HeadsUpConfig.minPlayers,
      maxPlayers: HeadsUpConfig.maxPlayers,
      minutes: 15,
      route: AppRoutes.headsUp,
      setupRoute: AppRoutes.headsUpSetup,
    ),
  ];

  /// Null for an unknown or removed id (e.g. persisted by an older version).
  static HomeGame? byId(String? id) {
    for (final game in games) {
      if (game.id == id) return game;
    }
    return null;
  }
}
