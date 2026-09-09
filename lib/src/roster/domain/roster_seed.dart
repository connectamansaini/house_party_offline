/// Turns the saved roster into a starting roster for a game with its own
/// player limits: blank names are dropped, the list is cut to [max], and
/// padded with "Player N" up to [min]. Returns exactly the defaults when
/// nothing is saved, so a first run looks the same as before.
List<String> seedRosterNames(
  List<String> saved, {
  required int min,
  required int max,
}) {
  final names = [
    for (final name in saved)
      if (name.trim().isNotEmpty) name.trim(),
  ].take(max).toList();
  while (names.length < min) {
    names.add('Player ${names.length + 1}');
  }
  return names;
}
