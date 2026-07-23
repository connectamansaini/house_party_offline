import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/data/repositories/imposter_settings_repository_impl.dart';
import 'package:house_party_offline/src/imposter/data/sources/imposter_settings_local_source.dart';
import 'package:house_party_offline/src/imposter/domain/entities/imposter_mode.dart';
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
      imposterMode: ImposterMode.undercover,
      categoryHintEnabled: true,
      discussionMinutes: 4,
      civilianWinPoints: 3,
      imposterWinPoints: 5,
      selectedPackIds: ['animals', 'foods'],
    );

    await repo.save(prefs);
    final loaded = await repo.load();

    expect(loaded, prefs);
    expect(loaded?.imposterMode, ImposterMode.undercover);
  });

  test('defaults to no selected packs', () async {
    const prefs = ImposterPreferences(
      playerNames: ['Solo'],
      imposterCount: 1,
      categoryHintEnabled: false,
      discussionMinutes: 3,
      civilianWinPoints: 1,
      imposterWinPoints: 2,
    );

    await repo.save(prefs);
    final loaded = await repo.load();

    expect(loaded?.selectedPackIds, isEmpty);
    expect(loaded, prefs);
  });

  test('migrates a legacy single selectedPackId', () async {
    // Simulate prefs written by the old single-pack version.
    await source.writePreferences({
      'playerNames': ['Ann'],
      'imposterCount': 1,
      'categoryHintEnabled': false,
      'discussionMinutes': 3,
      'civilianWinPoints': 1,
      'imposterWinPoints': 2,
      'selectedPackId': 'animals',
    });

    final loaded = await repo.load();
    expect(loaded?.selectedPackIds, ['animals']);
  });
}
