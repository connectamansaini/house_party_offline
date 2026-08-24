import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import 'package:house_party_offline/src/core/storage/hive_boxes.dart';
import 'package:house_party_offline/src/imposter/data/repositories/imposter_settings_repository_impl.dart';
import 'package:house_party_offline/src/imposter/data/repositories/word_pack_repository_impl.dart';
import 'package:house_party_offline/src/imposter/data/sources/bundled_word_source.dart';
import 'package:house_party_offline/src/imposter/data/sources/imposter_local_source.dart';
import 'package:house_party_offline/src/imposter/data/sources/imposter_settings_local_source.dart';
import 'package:house_party_offline/src/imposter/domain/engine/round_engine.dart';
import 'package:house_party_offline/src/imposter/domain/repositories/imposter_settings_repository.dart';
import 'package:house_party_offline/src/imposter/domain/repositories/word_pack_repository.dart';

/// Dependencies for the Imposter setup and game features.
///
/// The word-pack half of this graph is superseded by `imposter_packs` and will
/// retire with the Imposter setup slice; it is still live because `SetupCubit`
/// reads packs through the old [WordPackRepository].
void registerImposterDependencies(GetIt sl) {
  sl
    ..registerLazySingleton<RoundEngine>(RoundEngine.new)
    ..registerLazySingleton<BundledWordSource>(AssetBundledWordSource.new)
    ..registerLazySingleton<ImposterLocalSource>(
      () => HiveImposterLocalSource(
        Hive.box<Map<dynamic, dynamic>>(HiveBoxes.customWordPacks),
      ),
    )
    ..registerLazySingleton<ImposterSettingsLocalSource>(
      () => HiveImposterSettingsLocalSource(
        Hive.box<dynamic>(HiveBoxes.settings),
      ),
    )
    ..registerLazySingleton<WordPackRepository>(
      () => WordPackRepositoryImpl(bundled: sl(), local: sl()),
    )
    ..registerLazySingleton<ImposterSettingsRepository>(
      () => ImposterSettingsRepositoryImpl(sl()),
    );
}
