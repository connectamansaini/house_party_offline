import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/imposter_packs/data/datasources/imposter_packs_datasource.dart';
import 'package:house_party_offline/src/imposter_packs/data/repositories/imposter_packs_repository_impl.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/delete_custom_imposter_pack_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/save_custom_imposter_pack_usecase.dart';

void registerImposterPacksDependencies(GetIt sl) {
  sl.registerLazySingleton<ImposterPacksDataSource>(
    () => LocalImposterPacksDataSource(
      Hive.box<Map<dynamic, dynamic>>(HiveBoxes.customWordPacks),
    ),
  );
  sl.registerLazySingleton<ImposterPacksRepository>(
    () => ImposterPacksRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetImposterPacksUseCase>(
    () => GetImposterPacksUseCase(sl()),
  );
  sl.registerLazySingleton<SaveCustomImposterPackUseCase>(
    () => SaveCustomImposterPackUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteCustomImposterPackUseCase>(
    () => DeleteCustomImposterPackUseCase(sl()),
  );
}
