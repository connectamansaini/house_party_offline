import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';
import 'package:house_party_offline/src/home/presentation/bloc/home_bloc.dart';

class _FakeRecentGames implements RecentGamesRepository {
  _FakeRecentGames([this.stored]);

  String? stored;

  @override
  Future<String?> lastPlayedId() async => stored;

  @override
  Future<void> markPlayed(String gameId) async => stored = gameId;
}

Future<HomeState> _emitUntil(
  HomeBloc bloc,
  HomeEvent event,
  bool Function(HomeState state) predicate,
) {
  final future = bloc.stream.firstWhere(predicate);
  bloc.add(event);
  return future;
}

void main() {
  test('features the first game as "start here" before anything is played', () {
    final bloc = HomeBloc(_FakeRecentGames());

    expect(bloc.state.loaded, isFalse);
    expect(bloc.state.isFeaturedRecent, isFalse);
    expect(bloc.state.featured, GameCatalog.games.first);

    bloc.close();
  });

  test('HomeStarted loads the persisted last-played game', () async {
    final bloc = HomeBloc(_FakeRecentGames('mafia'));

    final state = await _emitUntil(bloc, const HomeStarted(), (s) => s.loaded);

    expect(state.isFeaturedRecent, isTrue);
    expect(state.featured.id, 'mafia');

    await bloc.close();
  });

  test('an unknown persisted id falls back to "start here"', () async {
    final bloc = HomeBloc(_FakeRecentGames('removed_game'));

    final state = await _emitUntil(bloc, const HomeStarted(), (s) => s.loaded);

    expect(state.lastPlayed, isNull);
    expect(state.isFeaturedRecent, isFalse);
    expect(state.featured, GameCatalog.games.first);

    await bloc.close();
  });

  test('HomeGameOpened features that game and persists it', () async {
    final repo = _FakeRecentGames();
    final bloc = HomeBloc(repo);

    final state = await _emitUntil(
      bloc,
      const HomeGameOpened('most_likely_to'),
      (s) => s.lastPlayedId == 'most_likely_to',
    );

    expect(state.featured.id, 'most_likely_to');
    expect(state.isFeaturedRecent, isTrue);
    // The write is fire-and-forget after the emit; let it land.
    await Future<void>.delayed(Duration.zero);
    expect(repo.stored, 'most_likely_to');

    await bloc.close();
  });

  test('every catalog entry resolves by id and has a sane player range', () {
    for (final game in GameCatalog.games) {
      expect(GameCatalog.byId(game.id), same(game));
      expect(game.minPlayers, lessThan(game.maxPlayers));
      expect(game.minutes, greaterThan(0));
    }
  });
}
