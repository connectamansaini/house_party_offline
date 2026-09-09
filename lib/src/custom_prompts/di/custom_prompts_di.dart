import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/custom_prompts/data/datasources/custom_prompts_datasource.dart';
import 'package:house_party_offline/src/custom_prompts/data/repositories/custom_prompts_repository_impl.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';

void registerCustomPromptsDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<CustomPromptsDataSource>(
      () => HiveCustomPromptsDataSource(Hive.box<dynamic>(HiveBoxes.settings)),
    )
    ..registerLazySingleton<CustomPromptsRepository>(
      () => CustomPromptsRepositoryImpl(sl()),
    );
}
