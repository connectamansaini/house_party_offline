import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/home/data/datasources/recent_games_datasource.dart';
import 'package:house_party_offline/src/home/data/repositories/recent_games_repository_impl.dart';

/// In-memory stand-in for the Hive settings box.
class _FakeDataSource implements RecentGamesDataSource {
  String? stored;
  bool throwOnRead = false;

  @override
  String? readLastPlayedId() {
    if (throwOnRead) throw StateError('box closed');
    return stored;
  }

  @override
  Future<void> writeLastPlayedId(String id) async => stored = id;
}

void main() {
  late _FakeDataSource dataSource;
  late RecentGamesRepositoryImpl repo;

  setUp(() {
    dataSource = _FakeDataSource();
    repo = RecentGamesRepositoryImpl(dataSource);
  });

  test('lastPlayedId is null before anything is marked', () async {
    expect(await repo.lastPlayedId(), isNull);
  });

  test('markPlayed then lastPlayedId round-trips', () async {
    await repo.markPlayed('mafia');
    expect(await repo.lastPlayedId(), 'mafia');
  });

  test('a read failure reads as nothing recent', () async {
    dataSource
      ..stored = 'imposter'
      ..throwOnRead = true;
    expect(await repo.lastPlayedId(), isNull);
  });
}
