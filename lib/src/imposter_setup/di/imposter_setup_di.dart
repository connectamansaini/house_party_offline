import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/imposter_setup/data/datasources/imposter_setup_preferences_datasource.dart';
import 'package:house_party_offline/src/imposter_setup/data/repositories/imposter_setup_preferences_repository_impl.dart';
import 'package:house_party_offline/src/imposter_setup/domain/repositories/imposter_setup_preferences_repository.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/load_imposter_setup_preferences_usecase.dart';
import 'package:house_party_offline/src/imposter_setup/domain/usecases/save_imposter_setup_preferences_usecase.dart';

void registerImposterSetupDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<ImposterSetupPreferencesDataSource>(
      () => HiveImposterSetupPreferencesDataSource(
        Hive.box<dynamic>(HiveBoxes.settings),
      ),
    )
    ..registerLazySingleton<ImposterSetupPreferencesRepository>(
      () => ImposterSetupPreferencesRepositoryImpl(sl()),
    )
    ..registerLazySingleton<LoadImposterSetupPreferencesUseCase>(
      () => LoadImposterSetupPreferencesUseCase(sl()),
    )
    ..registerLazySingleton<SaveImposterSetupPreferencesUseCase>(
      () => SaveImposterSetupPreferencesUseCase(sl()),
    );
}
