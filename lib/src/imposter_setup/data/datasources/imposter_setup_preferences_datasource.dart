import 'package:hive_ce/hive.dart';

/// Local persistence for the host's setup preferences.
abstract interface class ImposterSetupPreferencesDataSource {
  Map<dynamic, dynamic>? readPreferences();
  Future<void> writePreferences(Map<String, dynamic> map);
}

/// Hive-backed implementation storing a single preferences map in the
/// settings box.
class HiveImposterSetupPreferencesDataSource
    implements ImposterSetupPreferencesDataSource {
  HiveImposterSetupPreferencesDataSource(this._box);

  static const _key = 'setup_preferences';

  final Box<dynamic> _box;

  @override
  Map<dynamic, dynamic>? readPreferences() =>
      _box.get(_key) as Map<dynamic, dynamic>?;

  @override
  Future<void> writePreferences(Map<String, dynamic> map) =>
      _box.put(_key, map);
}
