import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/data/repositories/imposter_settings_repository_impl.dart';
import 'package:house_party_offline/src/imposter/data/sources/imposter_settings_local_source.dart';
import 'package:house_party_offline/src/imposter/domain/entities/imposter_preferences.dart';

/// In-memory stand-in for the Hive settings box.
class _FakeSource implements ImposterSettingsLocalSource {
  Map<dynamic, dynamic>? _stored;

  @override
  Map<dynamic, dynamic>? readPreferences() => _stored;

  @override
  Future<void> writePreferences(Map<String, dynamic> map) async =>
      _stored = map;
}

void main() {
  late _FakeSource source;
  late ImposterSettingsRepositoryImpl repo;

  setUp(() {
    source = _FakeSource();
    repo = ImposterSettingsRepositoryImpl(source);
  });

  test('load returns null before anything is saved', () async {
    expect(await repo.load(), isNull);
  });

  test('save then load round-trips all fields', () async {
    const prefs = ImposterPreferences(
      playerNames: ['Ann', 'Bo'],
      imposterCount: 2,
      categoryHintEnabled: true,
      discussionMinutes: 4,
      crewWinPoints: 3,
      imposterWinPoints: 5,
      selectedPackId: 'animals',
    );

    await repo.save(prefs);
    final loaded = await repo.load();

    expect(loaded, prefs);
  });

  test('handles a null selectedPackId', () async {
    const prefs = ImposterPreferences(
      playerNames: ['Solo'],
      imposterCount: 1,
      categoryHintEnabled: false,
      discussionMinutes: 3,
      crewWinPoints: 1,
      imposterWinPoints: 2,
    );

    await repo.save(prefs);
    final loaded = await repo.load();

    expect(loaded?.selectedPackId, isNull);
    expect(loaded, prefs);
  });
}
