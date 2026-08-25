import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';
import 'package:house_party_offline/src/imposter_setup/domain/repositories/imposter_setup_preferences_repository.dart';

class SaveImposterSetupPreferencesUseCase {
  const SaveImposterSetupPreferencesUseCase(this._repository);

  final ImposterSetupPreferencesRepository _repository;

  Future<void> call(ImposterSetupPreferencesEntity prefs) =>
      _repository.save(prefs);
}
