import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/network/auth_token_provider.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/interceptors/auth_interceptor.dart';
import '../../core/network/interceptors/error_interceptor.dart';
import '../../core/network/interceptors/logging_interceptor.dart';
import '../config/app_config.dart';
import '../config/app_endpoints.dart';

@module
abstract class InjectorModule {
  @lazySingleton
  IAppConfig get appConfig => const AppConfig.base();

  @lazySingleton
  IAppEndpoints appEndpoints(IAppConfig config) => AppEndpoints(config);

  @lazySingleton
  AuthTokenProvider get authTokenProvider => const EmptyAuthTokenProvider();

  @lazySingleton
  AuthInterceptor authInterceptor(AuthTokenProvider provider) =>
      AuthInterceptor(provider);

  @lazySingleton
  ErrorInterceptor get errorInterceptor => const ErrorInterceptor();

  @lazySingleton
  LoggingInterceptor get loggingInterceptor => const LoggingInterceptor();

  @lazySingleton
  Dio dio(
    IAppConfig config,
    AuthInterceptor authInterceptor,
    ErrorInterceptor errorInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: config.defaultHeaders,
      ),
    );
    dio.interceptors.addAll([
      authInterceptor,
      errorInterceptor,
      loggingInterceptor,
    ]);
    return dio;
  }

  @lazySingleton
  DioClient dioClient(Dio dio) => DioClient(dio);
}
