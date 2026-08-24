import 'package:house_party_offline/src/imposter/domain/entities/imposter_preferences.dart';

/// Stores the host's last-used setup choices between app launches.
abstract interface class ImposterSettingsRepository {
  /// Returns the saved preferences, or null if none have been saved yet.
  Future<ImposterPreferences?> load();

  Future<void> save(ImposterPreferences prefs);
}
