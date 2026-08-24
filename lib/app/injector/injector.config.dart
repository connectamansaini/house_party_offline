// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:house_party_offline/app/config/app_config.dart' as _i405;
import 'package:house_party_offline/app/injector/injector_module.dart' as _i397;
import 'package:injectable/injectable.dart' as _i526;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectorModule = _$InjectorModule();
    gh.lazySingleton<_i405.IAppConfig>(
      () => injectorModule.developmentConfig,
      registerFor: {_dev},
    );
    gh.lazySingleton<_i405.IAppConfig>(
      () => injectorModule.stagingConfig,
      registerFor: {_test},
    );
    gh.lazySingleton<_i405.IAppConfig>(
      () => injectorModule.productionConfig,
      registerFor: {_prod},
    );
    return this;
  }
}

class _$InjectorModule extends _i397.InjectorModule {}
