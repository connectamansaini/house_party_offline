/// Who narrates the next game.
///
/// With [rotate] on the job moves one seat down the roster from [lastHost],
/// wrapping back to the top; with it off the last narrator keeps it. Either
/// way an unknown or missing last host starts the rotation at the first
/// name, so a fresh roster never comes up empty.
String? nextHostName(
  List<String> names, {
  required String? lastHost,
  required bool rotate,
}) {
  if (names.isEmpty) return null;
  final index = lastHost == null ? -1 : names.indexOf(lastHost);
  if (index < 0) return names.first;
  if (!rotate) return names[index];
  return names[(index + 1) % names.length];
}
