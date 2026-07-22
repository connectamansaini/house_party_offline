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
    return ImposterPreferencesDto.fromMap(map).toDomain();
  }

  @override
  Future<void> save(ImposterPreferences prefs) async {
    await _local.writePreferences(
      ImposterPreferencesDto.fromDomain(prefs).toMap(),
    );
  }
}
