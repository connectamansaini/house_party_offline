import 'package:hive_ce/hive.dart';

/// Local persistence for the last-played game id.
abstract interface class RecentGamesDataSource {
  String? readLastPlayedId();
  Future<void> writeLastPlayedId(String id);
}

/// Hive-backed implementation storing a single string in the settings box.
class HiveRecentGamesDataSource implements RecentGamesDataSource {
  HiveRecentGamesDataSource(this._box);

  static const _key = 'last_played_game';

  final Box<dynamic> _box;

  @override
  String? readLastPlayedId() => _box.get(_key) as String?;

  @override
  Future<void> writeLastPlayedId(String id) => _box.put(_key, id);
}
