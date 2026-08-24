import 'package:house_party_offline/src/imposter/data/models/imposter_preferences_dto.dart';
import 'package:house_party_offline/src/imposter/data/sources/imposter_settings_local_source.dart';
import 'package:house_party_offline/src/imposter/domain/entities/imposter_preferences.dart';
import 'package:house_party_offline/src/imposter/domain/repositories/imposter_settings_repository.dart';

class ImposterSettingsRepositoryImpl implements ImposterSettingsRepository {
  ImposterSettingsRepositoryImpl(this._local);

  final ImposterSettingsLocalSource _local;

  @override
  Future<ImposterPreferences?> load() async {
    final map = _local.readPreferences();
    if (map == null) return null;
    try {
      return ImposterPreferencesDto.fromMap(map).toDomain();
    } on Object catch (_) {
      // Ignore preferences we can't parse (e.g. saved by an older version).
      return null;
    }
  }

  @override
  Future<void> save(ImposterPreferences prefs) async {
    await _local.writePreferences(
      ImposterPreferencesDto.fromDomain(prefs).toMap(),
    );
  }
}
