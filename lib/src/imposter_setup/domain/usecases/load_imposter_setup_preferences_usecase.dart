import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';
import 'package:house_party_offline/src/imposter_setup/domain/repositories/imposter_setup_preferences_repository.dart';

class LoadImposterSetupPreferencesUseCase {
  const LoadImposterSetupPreferencesUseCase(this._repository);

  final ImposterSetupPreferencesRepository _repository;

  Future<ImposterSetupPreferencesEntity?> call() => _repository.load();
}
