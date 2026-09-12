import 'package:hive_ce/hive.dart';

/// Local persistence for the Mafia narrator preferences.
abstract interface class MafiaHostPreferencesDataSource {
  Map<String, Object?>? read();

  Future<void> write(Map<String, Object?> values);
}

/// Hive-backed implementation storing one map in the settings box.
class HiveMafiaHostPreferencesDataSource
    implements MafiaHostPreferencesDataSource {
  HiveMafiaHostPreferencesDataSource(this._box);

  static const _key = 'mafia_host_preferences';

  final Box<dynamic> _box;

  @override
  Map<String, Object?>? read() {
    final stored = _box.get(_key);
    if (stored is! Map) return null;
    return {
      for (final entry in stored.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }

  @override
  Future<void> write(Map<String, Object?> values) => _box.put(_key, values);
}
