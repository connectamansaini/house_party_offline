import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/review/domain/review_gate.dart';

import '../helpers/fake_review_gate.dart';

void main() {
  ReviewGate gate(FakeStoreReview store, FakeReviewPreferences prefs) =>
      ReviewGate(store, prefs, delay: Duration.zero);

  test('does not ask before the threshold', () async {
    final store = FakeStoreReview();
    final prefs = FakeReviewPreferences();
    final g = gate(store, prefs);

    await g.onMatchCompleted();
    await g.onMatchCompleted();

    expect(store.requests, 0);
    expect(prefs.requested, isFalse);
    expect(prefs.completed, 2);
  });

  test('asks exactly once, at the threshold', () async {
    final store = FakeStoreReview();
    final prefs = FakeReviewPreferences(completed: 2);
    final g = gate(store, prefs);

    await g.onMatchCompleted();
    expect(store.requests, 1);
    expect(prefs.requested, isTrue);

    await g.onMatchCompleted();
    await g.onMatchCompleted();
    expect(store.requests, 1);
  });

  test('never asks again once it has, even after a fresh gate', () async {
    final store = FakeStoreReview();
    final prefs = FakeReviewPreferences(completed: 10, requested: true);

    await gate(store, prefs).onMatchCompleted();

    expect(store.requests, 0);
  });

  test('an unavailable store is not marked as asked, so it retries', () async {
    final store = FakeStoreReview(available: false);
    final prefs = FakeReviewPreferences(completed: 2);
    final g = gate(store, prefs);

    await g.onMatchCompleted();
    expect(store.requests, 0);
    expect(prefs.requested, isFalse);

    store.available = true;
    await g.onMatchCompleted();
    expect(store.requests, 1);
    expect(prefs.requested, isTrue);
  });
}
