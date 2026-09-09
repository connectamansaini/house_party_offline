/// The platform's in-app review flow (Play's review dialog on Android).
/// Abstracted so the ask-once policy can be tested without a store.
abstract interface class StoreReview {
  Future<bool> isAvailable();

  /// Asks the platform to show its review UI. The platform may silently
  /// decline (quota, no store account) — there is no way to know.
  Future<void> requestReview();
}
