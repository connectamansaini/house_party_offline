// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:house_party_offline/app/config/app_config.dart' as _i405;
import 'package:house_party_offline/app/config/app_endpoints.dart' as _i247;
import 'package:house_party_offline/app/injector/injector_module.dart' as _i397;
import 'package:house_party_offline/core/network/auth_token_provider.dart'
    as _i74;
import 'package:house_party_offline/core/network/dio_client.dart' as _i347;
import 'package:house_party_offline/core/network/interceptors/auth_interceptor.dart'
    as _i175;
import 'package:house_party_offline/core/network/interceptors/error_interceptor.dart'
    as _i851;
import 'package:house_party_offline/core/network/interceptors/logging_interceptor.dart'
    as _i542;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectorModule = _$InjectorModule();
    gh.lazySingleton<_i405.IAppConfig>(() => injectorModule.appConfig);
    gh.lazySingleton<_i74.AuthTokenProvider>(
      () => injectorModule.authTokenProvider,
    );
    gh.lazySingleton<_i851.ErrorInterceptor>(
      () => injectorModule.errorInterceptor,
    );
    gh.lazySingleton<_i542.LoggingInterceptor>(
      () => injectorModule.loggingInterceptor,
    );
    gh.lazySingleton<_i175.AuthInterceptor>(
      () => injectorModule.authInterceptor(gh<_i74.AuthTokenProvider>()),
    );
    gh.lazySingleton<_i247.IAppEndpoints>(
      () => injectorModule.appEndpoints(gh<_i405.IAppConfig>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => injectorModule.dio(
        gh<_i405.IAppConfig>(),
        gh<_i175.AuthInterceptor>(),
        gh<_i851.ErrorInterceptor>(),
        gh<_i542.LoggingInterceptor>(),
      ),
    );
    gh.lazySingleton<_i347.DioClient>(
      () => injectorModule.dioClient(gh<_i361.Dio>()),
    );
    return this;
  }
}

class _$InjectorModule extends _i397.InjectorModule {}
