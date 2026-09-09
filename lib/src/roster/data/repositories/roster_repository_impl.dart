import 'package:house_party_offline/src/roster/data/datasources/roster_datasource.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';

class RosterRepositoryImpl implements RosterRepository {
  RosterRepositoryImpl(this._dataSource);

  final RosterDataSource _dataSource;

  @override
  Future<List<String>> loadNames() async {
    try {
      return _dataSource.readNames() ?? const [];
    } on Object catch (_) {
      // A corrupt value just means "nothing saved" — never block a setup.
      return const [];
    }
  }

  @override
  Future<void> saveNames(List<String> names) async {
    try {
      await _dataSource.writeNames(names);
    } on Object catch (_) {
      // Purely a convenience; failing to remember names isn't worth surfacing.
    }
  }
}
