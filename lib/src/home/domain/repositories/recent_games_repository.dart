/// Remembers which game the host opened most recently, so the hub can offer
/// a one-tap "play again".
abstract interface class RecentGamesRepository {
  /// The `HomeGame.id` last opened, or null if none has been yet.
  Future<String?> lastPlayedId();

  Future<void> markPlayed(String gameId);
}
