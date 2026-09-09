import 'package:house_party_offline/src/review/domain/review_preferences.dart';
import 'package:house_party_offline/src/review/domain/store_review.dart';

/// Decides when to ask for a store review: once ever, after the host has
/// played [threshold] matches to the end, and only after a short [delay] so
/// the winner card is on screen before any dialog appears. A group that
/// has finished three games is the one worth asking.
class ReviewGate {
  ReviewGate(
    this._store,
    this._preferences, {
    this.threshold = 3,
    this.delay = const Duration(milliseconds: 1200),
  });

  final StoreReview _store;
  final ReviewPreferences _preferences;
  final int threshold;
  final Duration delay;

  /// Call when a match reaches its game-over screen.
  Future<void> onMatchCompleted() async {
    final completed = await _preferences.incrementCompletedMatches();
    if (completed < threshold) return;
    if (await _preferences.hasRequestedReview()) return;
    if (!await _store.isAvailable()) return;

    // Mark before showing: the platform gives no result back, and asking
    // twice is worse than never asking.
    await _preferences.markReviewRequested();
    await Future<void>.delayed(delay);
    await _store.requestReview();
  }
}
