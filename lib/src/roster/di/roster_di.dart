import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/roster/data/datasources/roster_datasource.dart';
import 'package:house_party_offline/src/roster/data/repositories/roster_repository_impl.dart';
import 'package:house_party_offline/src/roster/domain/repositories/roster_repository.dart';

void registerRosterDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<RosterDataSource>(
      () => HiveRosterDataSource(Hive.box<dynamic>(HiveBoxes.settings)),
    )
    ..registerLazySingleton<RosterRepository>(
      () => RosterRepositoryImpl(sl()),
    );
}
