import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/mafia_setup/data/datasources/mafia_host_preferences_datasource.dart';
import 'package:house_party_offline/src/mafia_setup/data/repositories/mafia_host_preferences_repository_impl.dart';
import 'package:house_party_offline/src/mafia_setup/domain/entities/mafia_host_preferences.dart';

class _FakeDataSource implements MafiaHostPreferencesDataSource {
  _FakeDataSource([this.stored]);

  Map<String, Object?>? stored;
  bool throwOnRead = false;
  bool throwOnWrite = false;

  @override
  Map<String, Object?>? read() {
    if (throwOnRead) throw StateError('corrupt');
    return stored;
  }

  @override
  Future<void> write(Map<String, Object?> values) async {
    if (throwOnWrite) throw StateError('disk full');
    stored = values;
  }
}

void main() {
  test('nothing stored means nobody has narrated yet', () async {
    final repo = MafiaHostPreferencesRepositoryImpl(_FakeDataSource());
    expect(await repo.load(), const MafiaHostPreferences());
  });

  test('a saved choice round-trips', () async {
    final source = _FakeDataSource();
    final repo = MafiaHostPreferencesRepositoryImpl(source);

    await repo.save(
      const MafiaHostPreferences(
        enabled: true,
        rotate: true,
        lastHostName: 'Ann',
      ),
    );

    expect(
      await repo.load(),
      const MafiaHostPreferences(
        enabled: true,
        rotate: true,
        lastHostName: 'Ann',
      ),
    );
  });

  test('an empty name reads back as nobody', () async {
    final repo = MafiaHostPreferencesRepositoryImpl(
      _FakeDataSource({'enabled': true, 'rotate': false, 'lastHostName': ''}),
    );
    final prefs = await repo.load();

    expect(prefs.enabled, isTrue);
    expect(prefs.lastHostName, isNull);
  });

  test('junk in the box never blocks a setup', () async {
    final repo = MafiaHostPreferencesRepositoryImpl(
      _FakeDataSource({'enabled': 'yes', 'rotate': 7}),
    );
    final prefs = await repo.load();

    expect(prefs.enabled, isFalse);
    expect(prefs.rotate, isFalse);
  });

  test('a read that throws falls back to the defaults', () async {
    final source = _FakeDataSource()..throwOnRead = true;
    final repo = MafiaHostPreferencesRepositoryImpl(source);

    expect(await repo.load(), const MafiaHostPreferences());
  });

  test('a write that throws is swallowed', () async {
    final source = _FakeDataSource()..throwOnWrite = true;
    final repo = MafiaHostPreferencesRepositoryImpl(source);

    await expectLater(
      repo.save(const MafiaHostPreferences(enabled: true)),
      completes,
    );
  });
}
