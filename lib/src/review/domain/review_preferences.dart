/// Persisted state behind the ask-once review policy.
abstract interface class ReviewPreferences {
  /// Bumps and returns the number of matches played to the end.
  Future<int> incrementCompletedMatches();

  /// Whether the review flow has ever been triggered on this device.
  Future<bool> hasRequestedReview();

  Future<void> markReviewRequested();
}
