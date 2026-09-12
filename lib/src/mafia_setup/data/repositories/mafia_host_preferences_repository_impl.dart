import 'package:house_party_offline/src/mafia_setup/data/datasources/mafia_host_preferences_datasource.dart';
import 'package:house_party_offline/src/mafia_setup/domain/entities/mafia_host_preferences.dart';
import 'package:house_party_offline/src/mafia_setup/domain/repositories/mafia_host_preferences_repository.dart';

class MafiaHostPreferencesRepositoryImpl
    implements MafiaHostPreferencesRepository {
  MafiaHostPreferencesRepositoryImpl(this._dataSource);

  static const _enabledKey = 'enabled';
  static const _rotateKey = 'rotate';
  static const _lastHostKey = 'lastHostName';

  final MafiaHostPreferencesDataSource _dataSource;

  @override
  Future<MafiaHostPreferences> load() async {
    try {
      final stored = _dataSource.read();
      if (stored == null) return const MafiaHostPreferences();
      final lastHost = stored[_lastHostKey];
      return MafiaHostPreferences(
        enabled: stored[_enabledKey] == true,
        rotate: stored[_rotateKey] == true,
        lastHostName: lastHost is String && lastHost.isNotEmpty
            ? lastHost
            : null,
      );
    } on Object catch (_) {
      // A corrupt value just means "nothing remembered" — never block setup.
      return const MafiaHostPreferences();
    }
  }

  @override
  Future<void> save(MafiaHostPreferences preferences) async {
    try {
      await _dataSource.write({
        _enabledKey: preferences.enabled,
        _rotateKey: preferences.rotate,
        _lastHostKey: preferences.lastHostName,
      });
    } on Object catch (_) {
      // Purely a convenience; forgetting who hosted isn't worth surfacing.
    }
  }
}
