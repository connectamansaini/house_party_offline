import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/review/data/hive_review_preferences.dart';
import 'package:house_party_offline/src/review/data/in_app_store_review.dart';
import 'package:house_party_offline/src/review/domain/review_gate.dart';
import 'package:house_party_offline/src/review/domain/review_preferences.dart';
import 'package:house_party_offline/src/review/domain/store_review.dart';

void registerReviewDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<StoreReview>(InAppStoreReview.new)
    ..registerLazySingleton<ReviewPreferences>(
      () => HiveReviewPreferences(Hive.box<dynamic>(HiveBoxes.settings)),
    )
    ..registerLazySingleton<ReviewGate>(() => ReviewGate(sl(), sl()));
}
