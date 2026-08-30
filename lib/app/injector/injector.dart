import 'package:get_it/get_it.dart';
import 'package:house_party_offline/app/injector/injector.config.dart';
import 'package:house_party_offline/src/imposter_game/di/imposter_game_di.dart';
import 'package:house_party_offline/src/imposter_packs/di/imposter_packs_di.dart';
import 'package:house_party_offline/src/imposter_setup/di/imposter_setup_di.dart';
import 'package:house_party_offline/src/mafia_game/di/mafia_game_di.dart';
import 'package:house_party_offline/src/never_have_i_ever/di/never_have_i_ever_di.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

/// Builds the dependency graph for [env] (`Environment.dev` / `test` / `prod`).
///
/// Registrations are lazy, so it is safe to call this before the Hive boxes are
/// opened in `bootstrap` — nothing touches storage until it is first resolved.
@InjectableInit()
Future<void> configureInjector(String env) async {
  getIt.init(environment: env);

  registerImposterPacksDependencies(getIt);
  registerImposterSetupDependencies(getIt);
  registerImposterGameDependencies(getIt);
  registerMafiaGameDependencies(getIt);
  registerNeverHaveIEverDependencies(getIt);
}
