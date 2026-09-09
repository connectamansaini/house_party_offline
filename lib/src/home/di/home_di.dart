import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/home/data/datasources/recent_games_datasource.dart';
import 'package:house_party_offline/src/home/data/repositories/recent_games_repository_impl.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';

void registerHomeDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<RecentGamesDataSource>(
      () => HiveRecentGamesDataSource(Hive.box<dynamic>(HiveBoxes.settings)),
    )
    ..registerLazySingleton<RecentGamesRepository>(
      () => RecentGamesRepositoryImpl(sl()),
    );
}
