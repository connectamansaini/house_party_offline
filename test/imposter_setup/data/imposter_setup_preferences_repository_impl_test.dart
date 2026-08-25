import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter_game/domain/entities/imposter_mode.dart';
import 'package:house_party_offline/src/imposter_setup/data/datasources/imposter_setup_preferences_datasource.dart';
import 'package:house_party_offline/src/imposter_setup/data/repositories/imposter_setup_preferences_repository_impl.dart';
import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';

/// In-memory stand-in for the Hive settings box.
class _FakeDataSource implements ImposterSetupPreferencesDataSource {
  Map<dynamic, dynamic>? _stored;

  @override
  Map<dynamic, dynamic>? readPreferences() => _stored;

  @override
  Future<void> writePreferences(Map<String, dynamic> map) async =>
      _stored = map;
}

void main() {
  late _FakeDataSource dataSource;
  late ImposterSetupPreferencesRepositoryImpl repo;

  setUp(() {
    dataSource = _FakeDataSource();
    repo = ImposterSetupPreferencesRepositoryImpl(dataSource);
  });

  test('load returns null before anything is saved', () async {
    expect(await repo.load(), isNull);
  });

  test('save then load round-trips all fields', () async {
    const prefs = ImposterSetupPreferencesEntity(
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
    const prefs = ImposterSetupPreferencesEntity(playerNames: ['Solo']);

    await repo.save(prefs);
    final loaded = await repo.load();

    expect(loaded?.selectedPackIds, isEmpty);
    expect(loaded, prefs);
  });

  test('migrates a legacy single selectedPackId', () async {
    // Simulate prefs written by the old single-pack version.
    await dataSource.writePreferences({
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
