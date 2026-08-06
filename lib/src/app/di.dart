import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import '../core/storage/hive_boxes.dart';
import '../imposter/data/repositories/imposter_settings_repository_impl.dart';
import '../imposter/data/repositories/word_pack_repository_impl.dart';
import '../imposter/data/sources/bundled_word_source.dart';
import '../imposter/data/sources/imposter_local_source.dart';
import '../imposter/data/sources/imposter_settings_local_source.dart';
import '../imposter/domain/engine/round_engine.dart';
import '../imposter/domain/repositories/imposter_settings_repository.dart';
import '../imposter/domain/repositories/word_pack_repository.dart';
import '../mafia/domain/engine/mafia_engine.dart';

/// Global service locator.
final GetIt sl = GetIt.instance;

/// Registers app-wide singletons. Call once during startup, after
/// [bootstrapStorage] has opened the Hive boxes.
Future<void> configureDependencies() async {
  // Domain
  sl.registerLazySingleton<RoundEngine>(RoundEngine.new);
  sl.registerLazySingleton<MafiaEngine>(MafiaEngine.new);

  // Imposter data sources
  sl.registerLazySingleton<BundledWordSource>(AssetBundledWordSource.new);
  sl.registerLazySingleton<ImposterLocalSource>(
    () => HiveImposterLocalSource(
      Hive.box<Map<dynamic, dynamic>>(HiveBoxes.customWordPacks),
    ),
  );
  sl.registerLazySingleton<ImposterSettingsLocalSource>(
    () => HiveImposterSettingsLocalSource(
      Hive.box<dynamic>(HiveBoxes.settings),
    ),
  );

  // Imposter repositories
  sl.registerLazySingleton<WordPackRepository>(
    () => WordPackRepositoryImpl(bundled: sl(), local: sl()),
  );
  sl.registerLazySingleton<ImposterSettingsRepository>(
    () => ImposterSettingsRepositoryImpl(sl()),
  );
}
