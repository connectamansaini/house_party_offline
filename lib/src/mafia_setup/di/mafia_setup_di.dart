import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/mafia_setup/data/datasources/mafia_host_preferences_datasource.dart';
import 'package:house_party_offline/src/mafia_setup/data/repositories/mafia_host_preferences_repository_impl.dart';
import 'package:house_party_offline/src/mafia_setup/domain/repositories/mafia_host_preferences_repository.dart';

void registerMafiaSetupDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<MafiaHostPreferencesDataSource>(
      () => HiveMafiaHostPreferencesDataSource(
        Hive.box<dynamic>(HiveBoxes.settings),
      ),
    )
    ..registerLazySingleton<MafiaHostPreferencesRepository>(
      () => MafiaHostPreferencesRepositoryImpl(sl()),
    );
}
