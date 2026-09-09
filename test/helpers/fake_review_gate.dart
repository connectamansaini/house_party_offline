import 'package:house_party_offline/app/injector/injector.dart';
import 'package:house_party_offline/src/review/domain/review_gate.dart';
import 'package:house_party_offline/src/review/domain/review_preferences.dart';
import 'package:house_party_offline/src/review/domain/store_review.dart';

class FakeStoreReview implements StoreReview {
  FakeStoreReview({this.available = true});

  bool available;
  int requests = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> requestReview() async => requests++;
}

class FakeReviewPreferences implements ReviewPreferences {
  FakeReviewPreferences({this.completed = 0, this.requested = false});

  int completed;
  bool requested;

  @override
  Future<int> incrementCompletedMatches() async => ++completed;

  @override
  Future<bool> hasRequestedReview() async => requested;

  @override
  Future<void> markReviewRequested() async => requested = true;
}

/// Registers a [ReviewGate] that never reaches the store and never leaves a
/// timer pending, for page tests that drive a match to game over.
void registerFakeReviewGate() {
  getIt.registerSingleton<ReviewGate>(
    ReviewGate(
      FakeStoreReview(available: false),
      FakeReviewPreferences(),
      delay: Duration.zero,
    ),
  );
}
