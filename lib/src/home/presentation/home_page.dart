import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/core/design/spacing.dart';
import 'package:house_party_offline/src/core/constants/app_strings.dart';
import 'package:house_party_offline/src/core/widgets/app_scaffold.dart';
import 'package:house_party_offline/src/core/widgets/entrance.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';
import 'package:house_party_offline/src/home/presentation/bloc/home_bloc.dart';
import 'package:house_party_offline/src/home/presentation/widgets/about_sheet.dart';
import 'package:house_party_offline/src/home/presentation/widgets/featured_game_card.dart';
import 'package:house_party_offline/src/home/presentation/widgets/game_card.dart';

/// The games hub: a large title, a featured "jump back in" card for the
/// last-played game, and a grid of every game with the facts a host needs
/// to choose (category, player range, length).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(getIt<RecentGamesRepository>())..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void _open(BuildContext context, HomeGame game, {bool toSetup = false}) {
    context.read<HomeBloc>().add(HomeGameOpened(game.id));
    context.push(toSetup ? game.setupRoute : game.route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const games = GameCatalog.games;

    return AppScaffold(
      appBar: AppBar(
        // A tall, left-aligned large title in the display face, so the app
        // name reads as a headline rather than a toolbar label.
        centerTitle: false,
        toolbarHeight: 84,
        titleSpacing: Spacing.x5l,
        title: Text(
          AppStrings.appTitle,
          style: const TextStyle(fontFamily: 'Unbounded').copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: scheme.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Spacing.md),
            child: IconButton(
              tooltip: 'About',
              onPressed: () => showAboutSheet(context),
              icon: const Icon(Icons.info_outline_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                Spacing.x5l,
                Spacing.md,
                Spacing.x5l,
                Spacing.x7l,
              ),
              children: [
                Entrance(
                  child: FeaturedGameCard(
                    // Keyed so the switch from "start here" to a recent game
                    // re-runs the entrance instead of mutating in place.
                    key: ValueKey('${state.featured.id}-${state.loaded}'),
                    game: state.featured,
                    isRecent: state.isFeaturedRecent,
                    onOpen: () => _open(context, state.featured),
                    onPlay: () => _open(context, state.featured, toSetup: true),
                  ),
                ),
                const SizedBox(height: Spacing.x8l),
                Entrance(
                  index: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('All games', style: theme.textTheme.titleLarge),
                      const SizedBox(width: Spacing.md),
                      Text(
                        '${games.length}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.x3l),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: Spacing.xl,
                  crossAxisSpacing: Spacing.xl,
                  childAspectRatio: 1.08,
                  children: [
                    for (var i = 0; i < games.length; i++)
                      Entrance(
                        index: i + 2,
                        child: GameCard(
                          game: games[i],
                          onTap: () => _open(context, games[i]),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
