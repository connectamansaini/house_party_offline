import 'package:hive_ce/hive.dart';

/// Local persistence for the shared roster.
abstract interface class RosterDataSource {
  List<String>? readNames();
  Future<void> writeNames(List<String> names);
}

/// Hive-backed implementation storing a single list in the settings box.
class HiveRosterDataSource implements RosterDataSource {
  HiveRosterDataSource(this._box);

  static const _key = 'roster_names';

  final Box<dynamic> _box;

  @override
  List<String>? readNames() {
    final stored = _box.get(_key);
    if (stored is! List) return null;
    return stored.whereType<String>().toList();
  }

  @override
  Future<void> writeNames(List<String> names) => _box.put(_key, names);
}
