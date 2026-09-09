/// The names of the people in the room, shared by every game's setup so the
/// host types them once. Saved whenever a game starts, loaded whenever a
/// setup screen opens.
abstract interface class RosterRepository {
  /// Saved names in order; empty if no game has been started yet.
  Future<List<String>> loadNames();

  Future<void> saveNames(List<String> names);
}
