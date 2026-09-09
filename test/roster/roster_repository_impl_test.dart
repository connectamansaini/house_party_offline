import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/roster/data/datasources/roster_datasource.dart';
import 'package:house_party_offline/src/roster/data/repositories/roster_repository_impl.dart';

/// In-memory stand-in for the Hive settings box.
class _FakeDataSource implements RosterDataSource {
  List<String>? stored;
  bool throwOnRead = false;

  @override
  List<String>? readNames() {
    if (throwOnRead) throw StateError('box closed');
    return stored;
  }

  @override
  Future<void> writeNames(List<String> names) async => stored = names;
}

void main() {
  late _FakeDataSource dataSource;
  late RosterRepositoryImpl repo;

  setUp(() {
    dataSource = _FakeDataSource();
    repo = RosterRepositoryImpl(dataSource);
  });

  test('loads empty before anything is saved', () async {
    expect(await repo.loadNames(), isEmpty);
  });

  test('save then load round-trips in order', () async {
    await repo.saveNames(['Bo', 'Ann']);
    expect(await repo.loadNames(), ['Bo', 'Ann']);
  });

  test('a read failure reads as empty', () async {
    dataSource
      ..stored = ['Ann']
      ..throwOnRead = true;
    expect(await repo.loadNames(), isEmpty);
  });
}
