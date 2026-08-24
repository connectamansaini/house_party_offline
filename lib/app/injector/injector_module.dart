import 'package:house_party_offline/app/config/app_config.dart';
import 'package:injectable/injectable.dart';

/// Bindings for types the app does not own the construction of.
///
/// Feature dependencies are registered by their own slice DI module (see
/// `registerImposterPacksDependencies`), not here.
@module
abstract class InjectorModule {
  @dev
  @lazySingleton
  IAppConfig get developmentConfig => const AppConfig.development();

  @test
  @lazySingleton
  IAppConfig get stagingConfig => const AppConfig.staging();

  @prod
  @lazySingleton
  IAppConfig get productionConfig => const AppConfig.production();
}
