import 'package:house_party_offline/src/home/data/datasources/recent_games_datasource.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';

class RecentGamesRepositoryImpl implements RecentGamesRepository {
  RecentGamesRepositoryImpl(this._dataSource);

  final RecentGamesDataSource _dataSource;

  @override
  Future<String?> lastPlayedId() async {
    try {
      return _dataSource.readLastPlayedId();
    } on Object catch (_) {
      // A corrupt value just means "nothing recent" — never block the hub.
      return null;
    }
  }

  @override
  Future<void> markPlayed(String gameId) async {
    try {
      await _dataSource.writeLastPlayedId(gameId);
    } on Object catch (_) {
      // Purely a convenience; failing to remember it isn't worth surfacing.
    }
  }
}
