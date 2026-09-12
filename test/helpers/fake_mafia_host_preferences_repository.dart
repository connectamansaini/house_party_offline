import 'package:house_party_offline/src/mafia_setup/domain/entities/mafia_host_preferences.dart';
import 'package:house_party_offline/src/mafia_setup/domain/repositories/mafia_host_preferences_repository.dart';

/// In-memory stand-in for what the Mafia setup remembers about narrating.
/// Starts at [stored] (nothing remembered by default) and records the last
/// save.
class FakeMafiaHostPreferencesRepository
    implements MafiaHostPreferencesRepository {
  FakeMafiaHostPreferencesRepository([
    this.stored = const MafiaHostPreferences(),
  ]);

  MafiaHostPreferences stored;

  @override
  Future<MafiaHostPreferences> load() async => stored;

  @override
  Future<void> save(MafiaHostPreferences preferences) async =>
      stored = preferences;
}
