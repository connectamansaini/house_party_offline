import 'package:house_party_offline/src/mafia_setup/domain/entities/mafia_host_preferences.dart';

/// Remembers how the last Mafia game was narrated. Read when a setup screen
/// opens, written when a game starts.
abstract interface class MafiaHostPreferencesRepository {
  Future<MafiaHostPreferences> load();

  Future<void> save(MafiaHostPreferences preferences);
}
