import 'package:house_party_offline/src/imposter_setup/domain/entities/imposter_setup_preferences_entity.dart';

/// Stores the host's last-used setup choices between app launches.
abstract interface class ImposterSetupPreferencesRepository {
  /// Returns the saved preferences, or null if none have been saved yet.
  Future<ImposterSetupPreferencesEntity?> load();

  Future<void> save(ImposterSetupPreferencesEntity prefs);
}
