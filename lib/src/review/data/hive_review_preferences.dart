import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/review/domain/review_preferences.dart';

/// [ReviewPreferences] stored in the settings box.
class HiveReviewPreferences implements ReviewPreferences {
  HiveReviewPreferences(this._box);

  static const _completedKey = 'completed_matches';
  static const _requestedKey = 'review_requested';

  final Box<dynamic> _box;

  @override
  Future<int> incrementCompletedMatches() async {
    final next = ((_box.get(_completedKey) as int?) ?? 0) + 1;
    await _box.put(_completedKey, next);
    return next;
  }

  @override
  Future<bool> hasRequestedReview() async =>
      (_box.get(_requestedKey) as bool?) ?? false;

  @override
  Future<void> markReviewRequested() => _box.put(_requestedKey, true);
}
