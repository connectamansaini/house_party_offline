import 'package:house_party_offline/src/review/domain/store_review.dart';
import 'package:in_app_review/in_app_review.dart';

/// [StoreReview] backed by the platform review APIs via `in_app_review`.
class InAppStoreReview implements StoreReview {
  InAppStoreReview([InAppReview? review])
    : _review = review ?? InAppReview.instance;

  final InAppReview _review;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _review.isAvailable();
    } on Object catch (_) {
      return false;
    }
  }

  @override
  Future<void> requestReview() async {
    try {
      await _review.requestReview();
    } on Object catch (_) {
      // A failed ask is indistinguishable from a declined one; move on.
    }
  }
}
