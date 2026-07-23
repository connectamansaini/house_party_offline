import '../../domain/entities/imposter_preferences.dart';
import '../../domain/repositories/imposter_settings_repository.dart';
import '../models/imposter_preferences_dto.dart';
import '../sources/imposter_settings_local_source.dart';

class ImposterSettingsRepositoryImpl implements ImposterSettingsRepository {
  ImposterSettingsRepositoryImpl(this._local);

  final ImposterSettingsLocalSource _local;

  @override
  Future<ImposterPreferences?> load() async {
    final map = _local.readPreferences();
    if (map == null) return null;
    try {
      return ImposterPreferencesDto.fromMap(map).toDomain();
    } catch (_) {
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
