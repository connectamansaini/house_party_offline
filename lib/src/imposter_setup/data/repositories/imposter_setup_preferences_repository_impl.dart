import 'package:house_party_offline/src/imposter_setup/data/datasources/imposter_setup_preferences_datasource.dart';
import 'package:house_party_offline/src/imposter_setup/data/models/imposter_setup_preferences_dto.dart';
import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';
import 'package:house_party_offline/src/imposter_setup/domain/failures/imposter_setup_failure.dart';
import 'package:house_party_offline/src/imposter_setup/domain/repositories/imposter_setup_preferences_repository.dart';

class ImposterSetupPreferencesRepositoryImpl
    implements ImposterSetupPreferencesRepository {
  ImposterSetupPreferencesRepositoryImpl(this._dataSource);

  final ImposterSetupPreferencesDataSource _dataSource;

  @override
  Future<ImposterSetupPreferencesEntity?> load() async {
    final map = _dataSource.readPreferences();
    if (map == null) return null;
    try {
      return ImposterSetupPreferencesDto.fromMap(map).toEntity();
    } on Object catch (_) {
      // Ignore preferences we can't parse (e.g. saved by an older version).
      return null;
    }
  }

  @override
  Future<void> save(ImposterSetupPreferencesEntity prefs) async {
    try {
      await _dataSource.writePreferences(
        ImposterSetupPreferencesDto.fromEntity(prefs).toJson(),
      );
    } on Object catch (_) {
      throw const ImposterSetupFailure(
        message: 'Could not save your setup preferences.',
        code: 'save_failed',
      );
    }
  }
}
