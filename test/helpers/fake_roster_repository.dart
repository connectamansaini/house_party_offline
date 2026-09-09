import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';

/// In-memory stand-in for the shared roster. Starts with [stored] (empty by
/// default) and records the last saved list.
class FakeRosterRepository implements RosterRepository {
  FakeRosterRepository([this.stored = const []]);

  List<String> stored;

  @override
  Future<List<String>> loadNames() async => stored;

  @override
  Future<void> saveNames(List<String> names) async => stored = names;
}
